#!/usr/bin/env bash

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"

# Options
shutdown=''
reboot=''
lock=''
suspend=''
logout=''

# Rofi CMD
rofi_cmd() {
	rofi -dmenu -p -theme ~/.config/rofi/powermenu/style.rasi
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$shutdown\n$reboot\n$lock\n$logout\n$suspend" | rofi_cmd
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $lock)
	hyprlock & playerctl -a stop & rmpc pause
	;;
    $suspend)
	~/scripts/battery_alert.sh delay
	;;
    $logout)
	hyprctl dispatch exit
        ;;
esac

