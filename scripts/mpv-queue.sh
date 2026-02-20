#!/bin/bash

# URL to queue
URL="$1"

# Send command to MPV via IPC
if [ -S /tmp/mpvsocket ]; then
    echo '{ "command": ["loadfile", "'"$URL"'", "append-play"] }' | socat - /tmp/mpvsocket
else
    # If MPV isn’t running, start a new instance
    mpv --force-window --input-ipc-server=/tmp/mpvsocket "$URL" &
fi
