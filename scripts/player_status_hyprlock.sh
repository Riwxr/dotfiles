#!/bin/bash

status=$(playerctl status 2>/dev/null)

case "$status" in
    Playing)
        echo "󰏤"   # play icon
        ;;
    Paused)
        echo "󰐊"   # pause icon
        ;;
    Stopped|"")
        echo "󰓛"   # stopped / no player
        ;;
    *)
        echo "󰓛"
        ;;
esac

