#!/usr/bin/env bash

swayosd-client --custom-message "Opening"

id=$(cat ~/.cache/mpv-history.log | sort -r | walker -d --minheight 1 -H)
if [[ $id =~ "|" ]]; then
    Url=$(echo "$id" | awk -F'|' '{gsub(/^ +| +$/, "", $3); print $3}')
else
    Url=$id
fi

setsid ~/scripts/qutebrowser/mpv.sh "$Url" >/dev/null 2>&1 &
