#!/usr/bin/env bash

blank=$(printf "\n ")

x=$(notify-send "󰑨  Screen Rotation $blank" "Choose Orintation -" -A Up -A Right -A Down -A Left)

hyprctl keyword monitor eDP-1,preferred,auto,1,transform,$x
