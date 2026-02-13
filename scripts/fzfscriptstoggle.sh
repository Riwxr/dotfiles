#!/usr/bin/env bash

if [[ $1 == k ]]; then
	hyprctl dispatch killwindow class:fzfscripts && hyprscratch fzfscripts "kitty --class "fzfscripts" -e ~/scripts/fzfscripts.sh" && notify-send "Fzf Scripts Reloaded" && hyprscratch fzfscripts hide
	exit 0
fi

if pgrep -fa "kitty --class fzfscripts" > /dev/null; then
	/usr/local/bin/hyprscratch fzfscripts toggle
else
	/usr/local/bin/hyprscratch fzfscripts "kitty --class "fzfscripts" -e ~/scripts/fzfscripts.sh"
fi

