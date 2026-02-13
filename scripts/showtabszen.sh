#!/usr/bin/env bash
active_class=$(hyprctl activewindow -j | jq -r '.class')

if [ "$active_class" = "zen" ]; then
    ydotool key 29:1 # Ctrl down
    ydotool key 15:1 # Tab down
    ydotool key 15:0 # Tab up

    TIMEOUT=1
    STATE_FILE=/tmp/last_event_time

    date +%s >"$STATE_FILE"

    # event watcher (background)
    {
        libinput debug-events | grep --line-buffered "POINTER"
        libinput debug-events | grep --line-buffered "GESTURE"
    } | while read -r _; do
        date +%s >"$STATE_FILE"
        echo "ping"
    done &

    # main inactivity loop
    while true; do
        now=$(date +%s)
        last_event=$(cat "$STATE_FILE")

        if ((now - last_event >= TIMEOUT)); then
            echo "inactive for $TIMEOUT second(s)"
            break
        fi

        sleep 0.05
    done
    ydotool key 29:0
    notify-send "ctrl up" -a toss
fi
