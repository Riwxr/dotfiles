#!/usr/bin/env bash

pkill -f battery-alert.sh

if [ "$(cat /sys/class/power_supply/BAT0/capacity)" -lt 5 ]; then
    exec ~/battery_alert.sh
fi
sleep 180

exec ~/battery_alert.sh
