#! /usr/bin/env bash

if [[ $(hyprctl activeworkspace | grep 'windows:' | awk '{print $2}') == 0 ]]; then
	printf ''
else
	echo "$(date +"%H:%M")"
fi
