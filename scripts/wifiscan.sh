#!/bin/bash

SSID="$1"

while true; do
    nmcli device wifi rescan >/dev/null 2>&1
    if nmcli device wifi list | grep -q "$SSID"; then
        notify-send "WiFi Detected" "$SSID is now available"
    else
        notify-send "WiFi Not Found" "$SSID not found"
    fi
    sleep 60
done

