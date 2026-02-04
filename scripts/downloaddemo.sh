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
id=$4

percent=$(( done * 100 / total ))

pro "$percent"


#id=$(notify-send -p "Downloding $title $blank" " 0% : $emptybar")
if [[ $percent -eq 100 ]]; then
	state="Download Complete--  "
	app=compl
else
	state="Downloading--  "
	app=repeat
fi
notify-send --replace-id=$id -a "$app" "$state$title$blank" " $done/$total : $blank$bar"
