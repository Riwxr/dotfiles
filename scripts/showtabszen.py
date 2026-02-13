import select
import subprocess
import time

TIMEOUT = 1

# press Ctrl+Tab
subprocess.run(["ydotool", "key", "29:1"])
subprocess.run(["ydotool", "key", "15:1"])
subprocess.run(["ydotool", "key", "15:0"])

p = subprocess.Popen(
    ["libinput", "debug-events"], stdout=subprocess.PIPE, text=True, bufsize=1
)

active = False
end_time = None

while True:
    ready, _, _ = select.select([p.stdout], [], [], 0.05)

    if ready:
        line = p.stdout.readline()

        if "GESTURE" in line:
            if "BEGIN" in line:
                active = True
                end_time = None

            elif "UPDATE" in line:
                active = True

            elif "END" in line:
                active = False
                end_time = time.time()

        # optional: also count mouse buttons as activity
        if "POINTER_BUTTON" in line:
            active = True
            end_time = None

    if not active and end_time:
        if time.time() - end_time > TIMEOUT:
            break

# release Ctrl
subprocess.run(["ydotool", "key", "29:0"])
subprocess.run(["notify-send", "ctrl up", "-a", "toss"])
