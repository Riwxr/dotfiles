#! /usr/bin/env bash

list=$(hyprctl -j clients | jq -r '.[].class' | sort -u | grep "zen")

if [[ -n $list ]]; then
	hyprctl dispatch focuswindow class:zen     
else
	zen-browser
fi
