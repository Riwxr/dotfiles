#!/usr/bin/env bash

blank=$(printf "\n ")

titlefull=$(rmpc song | jq -r ".metadata.title")
title="${titlefull%%[^a-zA-Z0-9._ -]*}"
state=$(rmpc status | jq -r ".state")
vol=$(rmpc status | jq -r ".volume")
elapsed=$(rmpc status | jq -r ".elapsed.secs")
dur=$(rmpc status | jq -r ".duration.secs")
repeat=$(echo "$status_json" | jq -r '.repeat')
single=$(echo "$status_json" | jq -r '.single')
id=4


case "$state" in 
	Play) icon="";;
	Pause) icon="";;
	Stop) icon="";;
	*) icon="";; 
esac

[ -z "$title" ] && title="No song" 


printf -v elapsed_fmt "%02d:%02d" $((elapsed/60)) $((elapsed%60))
printf -v dur_fmt "%02d:%02d" $((dur/60)) $((dur%60))

time="( $elapsed_fmt 󰿟 $dur_fmt )"


if [[ $1 == up ]]; then
	rmpc volume +5
	subheading=" $vol%   -    $title  "
	app=repeat
elif [[ $1 == down ]]; then
	rmpc volume -5
	subheading=" $vol%   -    $title  "
	app=repeat
elif [[ $1 == next ]]; then
	notify-send "  Rmpc - Deamon $blank" "     -      $title  " --replace-id=$id -a "$app"
	rmpc next
	sleep .1
	titlefull=$(rmpc song | jq -r ".metadata.title")
	title="${titlefull%%[^a-zA-Z0-9._ -]*}"
	subheading="$icon   -    $title  "
	app=repeat
elif [[ $1 == prev ]]; then
	notify-send "  Rmpc - Deamon $blank" " -  $title  " --replace-id=$id -a "$app"
	rmpc prev
	sleep .1
	titlefull=$(rmpc song | jq -r ".metadata.title")
	title="${titlefull%%[^a-zA-Z0-9._ -]*}"
	subheading="$icon   -    $title  "
	app=repeat
elif [[ $1 == toggle ]]; then
	rmpc togglepause
	subheading="$icon   -    $title  "
	app=repeat
elif [[ $1 == stop ]]; then
	rmpc pause
	subheading="   -    $title  "
	app=repeat
elif [[ $1 == seekf ]]; then
	rmpc seek +10
	subheading="$time   -    $title  "
	app=repeat
elif [[ $1 == seekb ]]; then
	rmpc seek -10
	subheading="$time   -    $title  "
	app=repeat
elif [[ $1 == rescan ]]; then
	rmpc rescan
	subheading="  Refreshed"
	app=repeat

elif [[ $1 == repeattoggle ]]; then
	if [[ $(cat ~/.cache/statusrmpcrepeat.txt) == 1 ]]; then
		rmpc repeat on
		rmpc single on
		subheading="  Repeat-Single -   $title  "
		printf "0" > ~/.cache/statusrmpcrepeat.txt
	elif [[ $(cat ~/.cache/statusrmpcrepeat.txt) == 0 ]]; then
		rmpc repeat off
		rmpc single off
		subheading="  Normal-   $title  "
		printf "1" > ~/.cache/statusrmpcrepeat.txt 
	fi
fi

notify-send "  Rmpc Deamon $blank" "$subheading" --replace-id=$id -a "$app"


