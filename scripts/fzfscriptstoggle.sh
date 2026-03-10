#!/usr/bin/env bash

if [[ $1 == k ]]; then
    hyprctl dispatch killwindow class:fzfscripts && hyprscratch fzfscripts "foot --app-id fzfscripts ~/scripts/fzfscripts.sh" && notify-send "Fzf Scripts Reloaded" && hyprscratch fzfscripts hide
    exit 0
fi

if hyprctl clients | grep -q '"class": "fzfscripts"' >/dev/null; then
    /usr/local/bin/hyprscratch fzfscripts toggle
else
    /usr/local/bin/hyprscratch fzfscripts "foot --app-id fzfscripts ~/scripts/fzfscripts.sh"
fi
