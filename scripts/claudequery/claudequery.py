#!/usr/bin/env python3
"""
claudequery.py — Send input.txt to claude.ai, write response to output.txt
Uses Ungoogled Chromium Flatpak + Playwright via CDP.

Usage:
    python claudequery.py                              # reads input.txt, writes output.txt
    python claudequery.py -i prompt.txt -o answer.txt  # custom paths
    python claudequery.py --timeout 180                # override response timeout
    python claudequery.py --debug                      # dump screenshot + page text on failure

Setup (first time):
    pip install playwright --break-system-packages
    playwright install chromium  # only needed if not using system Chromium via CDP
"""

import argparse
import logging
import subprocess
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

# ── Config ────────────────────────────────────────────────────────────────────

CHROMIUM_BIN = "/usr/bin/chromium"
CDP_PORT = 9222
CLAUDE_URL = "https://claude.ai/new"
HEADLESS = False  # flip to True once login is confirmed working

PROFILE_DIR = Path.home() / ".config" / "chromium-claudequery"

# ── Logging ───────────────────────────────────────────────────────────────────

logging.basicConfig(
    level=logging.INFO,
    format="[%(levelname)s] %(message)s",
)
log = logging.getLogger(__name__)

# ── CDP launch ────────────────────────────────────────────────────────────────


def _cdp_alive(port: int) -> bool:
    """Return True if the CDP /json endpoint answers."""
    try:
        with urllib.request.urlopen(f"http://localhost:{port}/json", timeout=1):
            return True
    except Exception:
        return False


def launch_chromium(cdp_port: int, profile_dir: Path) -> subprocess.Popen:
    """
    Launch system Chromium with CDP enabled.
    Kills only a previous claudequery-owned instance (tracked by sentinel arg),
    not every Chromium on the machine.
    """
    SENTINEL = "--claudequery-instance"

    # Kill only our own previous instance
    subprocess.run(
        ["pkill", "-f", SENTINEL],
        capture_output=True,
    )

    # Wait for the port to be free (up to 3 s)
    for _ in range(6):
        if not _cdp_alive(cdp_port):
            break
        time.sleep(0.5)

    profile_dir.mkdir(parents=True, exist_ok=True)

    cmd = [
        CHROMIUM_BIN,
        SENTINEL,  # our own sentinel flag
        f"--remote-debugging-port={cdp_port}",
        f"--user-data-dir={profile_dir}",
        "--no-first-run",
        "--no-default-browser-check",
        "--disable-blink-features=AutomationControlled",
        "--window-size=1280,900",
        "about:blank",
    ]
    if HEADLESS:
        cmd.append("--headless=new")

    # Watch for Chromium window map in background, then toggle it away immediately
    import threading

    def _watch_and_toggle():
        try:
            toggle_script = (
                Path.home() / "scripts" / "claudequery" / "togglechromium.sh"
            )
            watch_proc = subprocess.Popen(
                ["mmsg", "-wc"],
                stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL,
                text=True,
            )
            deadline = time.time() + 10
            for line in watch_proc.stdout:
                if time.time() > deadline:
                    break
                if "appid chromium" in line:
                    subprocess.run(["bash", str(toggle_script)], capture_output=True)
                    log.info("Chromium focus steal — toggled via togglechromium.sh.")
                    break
            watch_proc.terminate()
        except Exception as e:
            log.warning("Toggle watcher error: %s", e)

    threading.Thread(target=_watch_and_toggle, daemon=True).start()

    log.info("Launching Chromium (CDP on :%d) …", cdp_port)
    proc = subprocess.Popen(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    # Poll until CDP is ready instead of a fixed sleep
    deadline = time.time() + 15
    while time.time() < deadline:
        if _cdp_alive(cdp_port):
            log.info("CDP endpoint ready.")
            return proc
        time.sleep(0.4)

    proc.kill()
    raise RuntimeError(f"Chromium did not expose CDP on port {cdp_port} within 15 s.")


# ── Composer input ────────────────────────────────────────────────────────────

# Ordered from most to least reliable
_COMPOSER_SELECTORS = [
    '[data-testid="chat-input"]',
    'div[contenteditable="true"][aria-label]',
    'div[contenteditable="true"]',
    "textarea[placeholder]",
]


def find_composer(page):
    for sel in _COMPOSER_SELECTORS:
        el = page.query_selector(sel)
        if el and el.is_visible():
            log.info("Composer found via: %s", sel)
            return el
    return None


def type_into_composer(page, composer, prompt: str) -> None:
    composer.click()
    time.sleep(0.3)

    page.keyboard.press("Control+a")
    page.keyboard.press("Delete")
    time.sleep(0.2)

    escaped = prompt.replace("\\", "\\\\").replace("`", "\\`").replace("$", "\\$")
    page.evaluate(f"() => navigator.clipboard.writeText(`{escaped}`)")
    time.sleep(0.2)

    composer.click()
    page.keyboard.press("Control+v")
    time.sleep(0.6)  # give ProseMirror time to process

    actual = composer.inner_text().strip()

    if not actual:
        log.warning("Clipboard paste empty — falling back to keyboard.type …")
        composer.click()
        time.sleep(0.2)
        page.keyboard.press("Control+a")
        page.keyboard.press("Delete")
        page.keyboard.type(prompt, delay=12)
        time.sleep(0.5)
        actual = composer.inner_text().strip()

    if not actual:
        raise RuntimeError(
            "Failed to type prompt into composer — all methods exhausted."
        )

    log.info("Composer contains %d chars.", len(actual))


# ── Response extraction ───────────────────────────────────────────────────────

# Ordered from most to least specific
_RESPONSE_SELECTORS = [
    '[data-testid="assistant-message"]',
    '[data-is-streaming="false"]',
    ".font-claude-message",
    '[class*="AssistantMessage"]',
    '[class*="assistant-message"]',
]

_STOP_BUTTON_SELECTOR = 'button[aria-label="Stop response"]'
_WARN_SELECTORS = [
    '[class*="error"]',
    '[class*="warning"]',
    '[class*="capacity"]',
    '[class*="rate-limit"]',
]


def _check_for_warnings(page) -> None:
    for sel in _WARN_SELECTORS:
        el = page.query_selector(sel)
        if el:
            text = el.inner_text().strip()
            if text:
                log.warning("Possible UI warning detected: %r", text[:120])


def wait_for_response(page, timeout: int, debug: bool = False) -> str:
    from playwright.sync_api import TimeoutError as PWTimeout

    log.info("Waiting for streaming to begin …")

    # Phase 1: wait for the Stop button to appear (streaming started)
    try:
        page.wait_for_selector(_STOP_BUTTON_SELECTOR, timeout=20_000)
        log.info("Streaming started.")
    except PWTimeout:
        log.warning(
            "Stop button never appeared — response may have been instant or failed."
        )
        _check_for_warnings(page)

    # Phase 2: wait for the Stop button to disappear (streaming finished)
    log.info("Waiting for streaming to finish …")
    deadline = time.time() + timeout
    while time.time() < deadline:
        if not page.query_selector(_STOP_BUTTON_SELECTOR):
            log.info("Streaming complete.")
            break
        time.sleep(0.5)
    else:
        log.error("Timed out after %d s waiting for response.", timeout)
        if debug:
            _dump_debug(page)
        raise TimeoutError(f"Claude did not finish responding within {timeout} s.")

    time.sleep(0.8)  # brief settle for DOM to finalize

    # Phase 3: extract the last assistant message
    for sel in _RESPONSE_SELECTORS:
        els = page.query_selector_all(sel)
        if els:
            candidate = els[-1].inner_text().strip()
            # Strip the "Claude responded:" UI label if it leaked into inner_text
            for prefix in ("Claude responded:", "Claude:", "Assistant:"):
                if candidate.startswith(prefix):
                    candidate = candidate[len(prefix) :].strip()
            # Deduplicate: if the text is just the same paragraph twice, take the first half
            lines = candidate.splitlines()
            mid = len(lines) // 2
            if mid > 0 and lines[:mid] == lines[mid:]:
                candidate = "\n".join(lines[:mid]).strip()
            if len(candidate) > 30:
                log.info(
                    "Response captured via selector %r (%d chars).", sel, len(candidate)
                )
                return candidate
            else:
                log.debug(
                    "Selector %r matched but text too short (%r), skipping.",
                    sel,
                    candidate,
                )

    # Phase 4: structured body-text fallback
    log.warning("No selector matched cleanly — attempting body-text extraction …")
    body = page.inner_text("body")

    # Try to find the last block of text after a known response marker
    for marker in ["Claude responded:", "Assistant", "Claude:"]:
        if marker in body:
            after = body.split(marker)[-1].strip()
            # Trim off trailing UI chrome
            for footer in ["Claude is AI", "Sonnet", "Share", "Copy", "Retry"]:
                if footer in after:
                    after = after[: after.index(footer)].strip()
            if len(after) > 30:
                log.info("Extracted via body marker %r (%d chars).", marker, len(after))
                return after

    if debug:
        _dump_debug(page)

    raise RuntimeError(
        "Could not extract assistant response. "
        "Run with --debug to get a screenshot and page dump."
    )


def _dump_debug(page) -> None:
    debug_dir = Path("claudequery_debug")
    debug_dir.mkdir(exist_ok=True)
    ts = int(time.time())
    shot = debug_dir / f"screenshot_{ts}.png"
    dump = debug_dir / f"pagedump_{ts}.txt"
    try:
        page.screenshot(path=str(shot), full_page=True)
        log.info("Screenshot saved: %s", shot)
    except Exception as e:
        log.warning("Could not save screenshot: %s", e)
    try:
        dump.write_text(page.content(), encoding="utf-8")
        log.info("Page HTML saved: %s", dump)
    except Exception as e:
        log.warning("Could not save page dump: %s", e)


# ── Send button ───────────────────────────────────────────────────────────────

_SEND_SELECTORS = [
    'button[aria-label="Send message"]',
    'button[type="submit"]',
]


def send_message(page, composer) -> None:
    for sel in _SEND_SELECTORS:
        btn = page.query_selector(sel)
        if btn and btn.is_enabled():
            log.info("Sending via button: %s", sel)
            btn.click()
            return
    log.info("No send button found — pressing Enter.")
    composer.press("Enter")


# ── Main query flow ───────────────────────────────────────────────────────────


def query_claude(prompt: str, timeout: int, debug: bool) -> str:
    from playwright.sync_api import sync_playwright

    browser_proc = launch_chromium(CDP_PORT, PROFILE_DIR)

    try:
        with sync_playwright() as pw:
            log.info("Connecting to browser via CDP …")
            browser = pw.chromium.connect_over_cdp(f"http://localhost:{CDP_PORT}")
            context = browser.contexts[0] if browser.contexts else browser.new_context()
            page = context.new_page()

            log.info("Navigating to %s …", CLAUDE_URL)
            page.goto(CLAUDE_URL, wait_until="domcontentloaded", timeout=60_000)

            # Wait for the page to hydrate properly
            try:
                page.wait_for_load_state("networkidle", timeout=10_000)
            except Exception:
                pass  # networkidle can be flaky; domcontentloaded is enough

            if any(x in page.url for x in ("login", "sign-in", "auth")):
                log.error(
                    "Not logged in!\n"
                    "Run once headed to authenticate:\n"
                    "  HEADLESS=False python claudequery.py\n"
                    "  (or set HEADLESS = False in the script, log in, then flip it back)"
                )
                raise RuntimeError("Not authenticated — log in first.")

            log.info("Authenticated. Locating composer …")
            composer = find_composer(page)
            if not composer:
                if debug:
                    _dump_debug(page)
                raise RuntimeError(
                    "Composer not found. claude.ai DOM may have changed. "
                    "Run with --debug for a page dump."
                )

            type_into_composer(page, composer, prompt)
            time.sleep(0.3)
            send_message(page, composer)

            response = wait_for_response(page, timeout=timeout, debug=debug)
            browser.close()
            return response

    finally:
        # Always clean up the browser process
        if browser_proc.poll() is None:
            browser_proc.terminate()
            try:
                browser_proc.wait(timeout=5)
            except subprocess.TimeoutExpired:
                log.warning("Browser did not terminate cleanly — killing.")
                browser_proc.kill()


# ── Entry point ───────────────────────────────────────────────────────────────


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Query claude.ai via browser automation."
    )
    parser.add_argument(
        "-i", "--input", default="input.txt", help="Input file  (default: input.txt)"
    )
    parser.add_argument(
        "-o", "--output", default="output.txt", help="Output file (default: output.txt)"
    )
    parser.add_argument(
        "-t",
        "--timeout",
        default=120,
        type=int,
        help="Max seconds to wait for response (default: 120)",
    )
    parser.add_argument(
        "--debug",
        action="store_true",
        help="On failure: save screenshot + page HTML to ./claudequery_debug/",
    )
    parser.add_argument(
        "--verbose", action="store_true", help="Show DEBUG-level log messages"
    )
    args = parser.parse_args()

    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)

    input_path = Path(args.input)
    output_path = Path(args.output)

    if not input_path.exists():
        log.error("Input file not found: %s", input_path)
        sys.exit(1)

    prompt = input_path.read_text(encoding="utf-8").strip()
    if not prompt:
        log.error("Input file is empty.")
        sys.exit(1)

    log.info("Read %d chars from %s", len(prompt), input_path)

    try:
        response = query_claude(prompt, timeout=args.timeout, debug=args.debug)
    except KeyboardInterrupt:
        log.info("Interrupted by user.")
        sys.exit(1)
    except Exception as e:
        log.error("Fatal error: %s", e)
        if args.debug:
            import traceback

            traceback.print_exc()
        sys.exit(1)

    output_path.write_text(response, encoding="utf-8")
    log.info("Response written to %s  (%d chars)", output_path, len(response))


if __name__ == "__main__":
    main()
