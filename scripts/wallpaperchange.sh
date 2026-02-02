#!/usr/bin/env bash

var="$1"

if [[ -z "$var" ]]; then
    echo "Usage: $0 <image-path>"
    exit 1
fi


wal -i $var --saturate 0.3

swww img $(cat ~/.cache/wal/wal)

pkill swaync
hyprctl dispatch exec swaync &

pkill -9 swayosd-server && swayosd-server &


