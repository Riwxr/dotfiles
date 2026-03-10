#!/usr/bin/env bash

sec_count=$(hyprctl clients -j | jq -r '.[] | select(.class == "mpv")' | jq -r 'select(.workspace.name=="2") | 1' | wc -l)
mpv_count=$(hyprctl clients -j | jq -r '.[] | select(.class == "mpv")' | jq -r 'select(.workspace.name=="special:mpv") | 1' | wc -l)

if [[ $sec_count -eq 0 ]] && [[ $mpv_count -eq 0 ]]; then
    exit 0
fi
echo "$sec_count:$mpv_count"
