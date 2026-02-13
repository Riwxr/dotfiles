#! /usr/bin/env bash
 
[[ $1 == c ]] && rmpc clear

title=$(rmpc listall | { echo ":"; cat; } | fzf -i)


if [[ $title == : ]]; then
	playlist=$(rmpc listall | cut -d'/' -f1 | sort -u | fzf)
	rmpc add "$playlist"
else
	rmpc add "$title"
fi
rmpc play

titlefull=$(rmpc song | jq -r ".metadata.title")
tit="${titlefull%%[^a-zA-Z0-9._ -]*}"
app=repeat
blank=$(printf "\n ")


notify-send "  Rmpc - Deamon $blank" "  -   $tit  " -a "$app"
