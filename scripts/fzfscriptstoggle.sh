#!/usr/bin/env bash

if [[ $1 == k ]]; then
	notify-send "changed" && exit 0
	hyprctl dispatch killwindow class:fzfscripts
	/usr/local/bin/hyprscratch fzfscripts "kitty --class "fzfscripts" -e ~/scripts/fzfscripts.sh"
	/usr/local/bin/hyprscratch fzfscripts hide
fi

if pgrep -fa "kitty --class fzfscripts" > /dev/null; then
	/usr/local/bin/hyprscratch fzfscripts toggle
else
	/usr/local/bin/hyprscratch fzfscripts "kitty --class "fzfscripts" -e ~/scripts/fzfscripts.sh"
fi

