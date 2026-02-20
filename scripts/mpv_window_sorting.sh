#!/usr/bin/env bash

#notify-send -a toss "moving"

hyprctl clients -j | jq -r '.[] | select(.class == "mpv")' >~/.cache/mpvlistsort.json

sec_count=$(jq -r 'select(.workspace.name=="2") | 1' ~/.cache/mpvlistsort.json | wc -l)
mpv_count=$(jq -r 'select(.workspace.name=="special:mpv") | 1' ~/.cache/mpvlistsort.json | wc -l)
echo "mpv on workspace 2: $sec_count"
echo "mpv on special:mpv: $mpv_count"

if [[ $sec_count -gt 0 ]]; then
    echo file exists, move others to special
    pid=$(jq -r 'select(.workspace.name == "2") | .pid' ~/.cache/mpvlistsort.json | head -n 1)
    #exit 0
elif [[ $sec_count -eq 0 ]] && [[ $mpv_count -gt 0 ]]; then
    echo file exists but not fuckin visible
    pid=$(jq -r 'select(.workspace.name == "2") | .pid' ~/.cache/mpvlist.json | head -n 1)
    hyprctl dispatch movetoworkspacesilent 2, pid:"$pid"
    exit 0
fi

mapfile -t all_pids < <(jq -r '.pid' ~/.cache/mpvlistsort.json)

other_pids=()
for p in "${all_pids[@]}"; do
    if [[ "$p" != "$pid" ]]; then
        other_pids+=("$p")
    fi
done

for d in "${other_pids[@]}"; do
    hyprctl dispatch movetoworkspacesilent special:mpv, pid:"$d"
done
