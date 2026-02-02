#!/bin/bash

DIR="$HOME/Pictures/Screenshots"
FILE="${DIR}/Arch_window$(date "+%Y%m%d_%H%M%S").png"
IP=$(adb devices | awk 'NR==2 {print $1}')

# take screenshot from monitor eDP-1
flameshot gui -p $FILE"

# wait for screenshot to appear
while [[ ! -f "$FILE" ]]; do
    sleep 0.2
done

# send via adb or/ifnot kdeconnect

if [ -n "$IP" ]; then
	adb -s "$IP" push "$FILE" /sdcard/Arch/ && swayosd-client --custom-message "ScreenShot Sent"
else
	swayosd-client --custom-message "ABD not connected"
	kdeconnect-cli -d 6ca5270e76644a3ab423b69961694d00 --share "$FILE"
fi
