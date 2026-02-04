#!/usr/bin/env bash

active_class=$(hyprctl activewindow -j | jq -r '.class')

if [ "$active_class" = "microsoft-edge" ]; then
	if [[ $1 == d ]]; then
		wtype -M ctrl -k Tab -m ctrl
	elif [[ $1 == u ]]; then
		wtype -M ctrl -M shift -k Tab -m ctrl -m shift
	fi
fi
