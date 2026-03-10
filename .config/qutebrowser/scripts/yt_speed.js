(function() {
    if (!location.hostname.includes("youtube.com")) return;

    const speeds = [1.5, 2];
    const videos = document.querySelectorAll("video");
    if (!videos.length) return;

    const current = speeds.includes(videos[0].playbackRate)
        ? videos[0].playbackRate
        : 1.5;

    const next = speeds[(speeds.indexOf(current) + 1) % speeds.length];
    videos.forEach(a => a.playbackRate = next);

    let badge = document.getElementById("qute-speed-indicator");
    if (!badge) {
        badge = document.createElement("div");
        badge.id = "qute-speed-indicator";
        Object.assign(badge.style, {
            position: "fixed",
            bottom: "20px",
            right: "20px",
            background: "rgba(0,0,0,0.85)",
            color: "white",
            padding: "6px 12px",
            borderRadius: "6px",
            fontSize: "14px",
            zIndex: 99999,
            transition: "opacity 0.2s"
        });
        document.body.appendChild(badge);
    }

    badge.textContent = "Speed: " + next + "x";
    badge.style.opacity = "1";
    setTimeout(() => badge.style.opacity = "0", 1000);
})();

