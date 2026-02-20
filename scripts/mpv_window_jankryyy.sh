#!/usr/bin/env bash
set -euo pipefail

pgrep dmenu && killall dmenu && echo "DMENU_ALREADY_EXISTED" && exit 1

hyprctl clients -j | jq -r '.[] | select(.class == "mpv")' >~/.cache/mpvlist.json

sec_count=$(jq -r 'select(.workspace.name=="2") | 1' ~/.cache/mpvlist.json | wc -l)
mpv_count=$(jq -r 'select(.workspace.name=="special:mpv") | 1' ~/.cache/mpvlist.json | wc -l)
# echo "mpv on workspace 2: $sec_count"
# echo "mpv on special:mpv: $mpv_count"

if [[ $sec_count -eq 0 ]] && [[ $mpv_count -eq 0 ]]; then
    qutebrowser "https://www.youtube.com"
    hyprctl dispatch focuswindow class:org.qutebrowser.qutebrowser >/dev/null
    exit 0
fi

if [[ $sec_count -eq 0 ]] && [[ $mpv_count -gt 0 ]]; then
    echo file exists but not fuckin visible
    pid=$(jq -r 'select(.workspace.name == "special:mpv") | .pid' ~/.cache/mpvlist.json | head -n 1)
    #exit 0
else
    title_pid=$(cat ~/.cache/mpvlist.json | jq -r '"\(.title) \(.pid)"' | dmenu -l 9)
    pid=$(echo "$title_pid" | awk '{print $NF}')
fi

if [[ -z $pid ]]; then
    echo "NO_PID_SELECTED"
    exit 2
fi

mapfile -t all_pids < <(jq -r '.pid' ~/.cache/mpvlist.json)

other_pids=()
for p in "${all_pids[@]}"; do
    if [[ "$p" != "$pid" ]]; then
        other_pids+=("$p")
    fi
done

busctl --user list | grep mpris.MediaPlayer2.mpv >~/.cache/mpvinstance.log

workspace=$(hyprctl clients -j | jq -r --arg pid "$pid" '.[] | select(.pid == ($pid|tonumber)) | .workspace.name')

if [[ "$workspace" == "special:mpv" ]]; then
    hyprctl dispatch movetoworkspace 2, pid:"$pid" >/dev/null

    ins=$(awk -v pid="$pid" '$2==pid {sub(/^org\.mpris\.MediaPlayer2\./,""); print $1}' ~/.cache/mpvinstance.log)
    playerctl -p "$ins" play
    hyprctl dispatch focuswindow pid:"$pid" >/dev/null
    for d in "${other_pids[@]}"; do
        hyprctl dispatch movetoworkspacesilent special:mpv, pid:"$d"

        insd=$(awk -v pid="$d" '$2==pid {sub(/^org\.mpris\.MediaPlayer2\./,""); print $1}' ~/.cache/mpvinstance.log)
        playerctl -p "$insd" pause

    done
else
    if [[ $sec_count -eq 1 ]]; then
        exit 0
    else
        hyprctl dispatch movetoworkspacesilent special:mpv, pid:"$pid" >/dev/null
    fi
fi

~/scripts/mpv_window_sorting.sh >/dev/null
