#! /usr/bin/env bash
 
[[ $1 == c ]] && rmpc clear

title=$(rmpc listall | { echo ":"; cat; } | fzf)


if [[ $title == : ]]; then
	playlist=$(rmpc listall | cut -d'/' -f1 | sort -u | fzf)
	rmpc add "$playlist"
else
	rmpc add "$title"
fi

rmpc play

