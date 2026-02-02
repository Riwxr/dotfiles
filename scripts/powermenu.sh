#!/bin/env bash

# Options for powermenu
lock=""
logout=""
shutdown=""
reboot=""
sleep=""

# Get answer from user via rofi
selected_option=$(echo "$shutdown
$reboot
$lock
$logout
$sleep" | rofi -dmenu -i -p "Power")
# Do something based on selected option
if [ "$selected_option" == "$lock" ]; then
    betterlockscreen --lock
elif [ "$selected_option" == "$logout" ]; then
    loginctl terminate-user `whoami`
elif [ "$selected_option" == "$shutdown" ]; then
    mpv ~/Music/alaram/shutdown.mp3 &
    doas systemctl poweroff
elif [ "$selected_option" == "$reboot" ]; then
    doas systemctl reboot
elif [ "$selected_option" == "$sleep" ]; then
    amixer set Master mute
    doas systemctl suspend
else
    echo "No match"
fi

