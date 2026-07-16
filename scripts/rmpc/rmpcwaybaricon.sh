#!/usr/bin/env bash

state=$(rmpc status | jq -r '.state')
song=$(rmpc song | jq -r '.metadata.title')

# Truncate to 30 chars
max=15
if [ ${#song} -gt $max ]; then
    song="${song:0:$max}_"
fi

if [ "$state" == "Play" ]; then
    class="playing"
    icon=""
elif [ "$state" == "Pause" ]; then
    class="paused"
    icon=""
else
    class="stopped"
    icon=""
fi

echo "{\"text\": \"$icon $song\", \"class\": \"$class\", \"tooltip\": \"$song\"}"
