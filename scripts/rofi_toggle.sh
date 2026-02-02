#!/usr/bin/env bash

# Check if Rofi is already running
ROFI_PID=$(pgrep -x rofi)

if [ -n "$ROFI_PID" ]; then
    # If running, kill it
    kill $ROFI_PID
else
    # If not running, start Rofi with your theme
    rofi -show drun 
fi

