#!/usr/bin/env bash

active_class=$(hyprctl activewindow -j | jq -r '.class')
layer=$(hyprctl -j layers | jq -r '.[].levels[][]?.namespace' | grep -Fx "rofi")

if [[ $layer == rofi ]]; then
	pkill rofi 
	exit 0
fi

msgs=(
"NOPE."
"That's it. Calm down."
"UH-HUH."
"You Shall NOT Pass Through Under My Watch."
"Access denied."
"NO."
"This ends here."
"You’ve gone too far."
"Think again, kid."
"We talked about this."
"Stop it, Jimmy."
"No, son."
"That’s enough."
)

msg="${msgs[$RANDOM % ${#msgs[@]}]}"

blank=$(printf "\n ")

if [ "$active_class" = "zen" ]; then
	notify-send " Watchdog - Zen $blank" "  $msg"
elif [ "$active_class" = "microsoft-edge" ]; then
	notify-send " Watchdog - Msedge $blank" "  $msg"
elif [ "$active_class" = "sleek" ]; then
    /usr/local/bin/hyprscratch sleek toggle

elif [ "$active_class" = "rmpc" ]; then
    /usr/local/bin/hyprscratch rmpc toggle

elif [ "$active_class" = "org.kde.kdeconnect.app" ]; then
    /usr/local/bin/hyprscratch "KDE Connect" toggle

else
    hyprctl dispatch killactive
fi

pkill -RTMIN+3 waybar
