#!/bin/bash

### ---- Bluetooth ----
bt_icon="󰂯"
bt_device=$(bluetoothctl info 2>/dev/null | grep "Name:" | cut -d' ' -f2-)

if [ -n "$bt_device" ]; then
    bt_out="$bt_icon $bt_device"
fi

### ---- Wi-Fi ----
wifi_icon="󰤨"   # keep static (simple as you asked)
wifi_ssid=$(iw dev 2>/dev/null | awk '/ssid/ {print substr($0, index($0,$2))}')

if [ -n "$wifi_ssid" ]; then
    wifi_out="$wifi_icon $wifi_ssid"
fi

### ---- Output ----
if [ -n "$bt_out" ] && [ -n "$wifi_out" ]; then
    echo "$bt_out | $wifi_out"
elif [ -n "$bt_out" ]; then
    echo "$bt_out"
elif [ -n "$wifi_out" ]; then
    echo "$wifi_out"
else
    echo ""
fi

