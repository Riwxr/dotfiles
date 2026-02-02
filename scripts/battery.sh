#!/bin/bash

BAT="/sys/class/power_supply/BAT0"

capacity=$(cat "$BAT/capacity")
status=$(cat "$BAT/status")

# Icons (same order as Waybar)
icons=("" "" "" "" "")

# Pick icon based on percentage
if   (( capacity <= 20 )); then icon="${icons[0]}"
elif (( capacity <= 40 )); then icon="${icons[1]}"
elif (( capacity <= 60 )); then icon="${icons[2]}"
elif (( capacity <= 80 )); then icon="${icons[3]}"
else                           icon="${icons[4]}"
fi

# Status overrides
case "$status" in
    Charging)
        echo "   ${capacity}%"
        ;;
    Full)
        echo "${icon}  ${capacity}%"
        ;;
    *)
        echo "${icon}  ${capacity}%"
        ;;
esac

