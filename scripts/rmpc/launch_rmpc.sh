#!/bin/sh

mpd ~/.config/mpd/mpd.conf

# Don’t spawn duplicates
if hyprctl clients | grep -q '"class": "rmpc"'; then
    exit 0
fi


kitty --class rmpc --title rmpc rmpc

