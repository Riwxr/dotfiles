#!/bin/bash

SSID="$1"

while true; do
    nmcli device wifi rescan >/dev/null 2>&1
    if nmcli device wifi list | grep -q "$SSID"; then
        notify-send "WiFi Detected" "$SSID is now available"
        tnotify "WiFi Detected" "$SSID is now available"
        exit 0
    else
        notify-send "❌ WiFi Not Found" "$SSID not found"
    fi
    sleep 6
done
