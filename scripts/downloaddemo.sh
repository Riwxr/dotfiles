#!/usr/bin/env bash
blank=$(printf "\n ")

emptybar="░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
pro() {
	local percent=$1
	local replacement="█████████████████████████████████████"
	local X=${#emptybar}
	local N=$(( X * percent / 100 ))
	local remaining="${emptybar:N}"
	local added="${replacement:0:N}"
	bar=$added$remaining
}

done=$1
total=$2
title=$3
subtitle=$4
id=$5

percent=$(( done * 100 / total ))

pro "$percent"


#id=$(notify-send -p "Downloding $title $blank" " 0% : $emptybar")
if [[ $percent -eq 100 ]]; then
	state="Download Complete--  "
	app="done"
else
	state="Downloading--  "
	app="repeat"
fi
notify-send --replace-id=$id -a "$app" "$title" "$state$subtitle$blank $percent%    ($done/$total): $blank$bar"
