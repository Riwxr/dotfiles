#!/usr/bin/env bash

if pgrep -x rofi >/dev/null; then
    pkill rofi
    exit 0
fi
active_appid=$(mmsg -g -c | awk '/appid/{print $3}')
msgs=(
    "NOPE."
    "That's it. Calm down."
    "UH-HUH."
    "You Shall NOT Pass Through Under My Watch."
    "Access denied."
    "NO."
    "This ends here."
    "You've gone too far."
    "Think again, kid."
    "We talked about this."
    "Stop it, Jimmy."
    "No, son."
    "That's enough."
)
msg="${msgs[$RANDOM%${#msgs[@]}]}"
blank=$(printf "\n ")

case "$active_appid" in
zen)
    notify-send " Watchdog - Zen $blank" "  $msg"
    ;;
one.ablaze.floorp)
    notify-send " Watchdog - Floorp $blank" "  $msg"
    ;;
mpv)
    notify-send " Watchdog - MPV $blank" "  $msg"
    ;;
org.qutebrowser.qutebrowser)
    notify-send " Watchdog - Qutebrowser $blank" "  $msg"
    ;;
sleek)
    mmsg -d toggle_named_scratchpad,sleek,none,1,1,sleek
    ;;
rmpc)
    mmsg -d toggle_named_scratchpad,rmpc,none,1,1,rmpc
    ;;
fzfscripts)
    mmsg -d toggle_named_scratchpad,fzfscripts,none,1,1,fzfscripts
    ;;
org.kde.kdeconnect.app)
    mmsg -d toggle_named_scratchpad,org.kde.kdeconnect.app,none,1,1,kdeconnect-app
    ;;
*)
    mmsg -d killclient
    ;;
esac

pkill -RTMIN+3 waybar
