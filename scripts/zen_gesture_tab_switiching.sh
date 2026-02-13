#!/usr/bin/env bash

libinput debug-events --device /dev/input/event13 | while read -r line; do
    if [[ "$line" == *"GESTURE_SWIPE_BEGIN"* ]]; then
        echo "begin"
    fi

    if [[ "$line" == *"GESTURE_SWIPE_UPDATE"* ]]; then
        echo "update"
    fi

    if [[ "$line" == *"GESTURE_SWIPE_END"* ]]; then
        echo "end"
    fi
done

