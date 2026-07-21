#!/usr/bin/env bash

# Check if rmpc client is alive
if mmsg -g -c | grep -q 'appid rmpc'; then
    # Exists → toggle
    last_tag=$(cat ~/.cache/lasttag.log)
    mmsg -s -t "$last_tag"
else
    # Doesn't exist → launch
    tag=$(mmsg -g -t | awk '/^[^ ]+ tag [0-9]+ 1/ {print $3}')
    echo "$tag" >~/.cache/lasttag.log
    mmsg -s -t 9
    if ! mmsg -g -c | grep -q 'appid rmpc'; then
        foot --app-id "rmpc" rmpc
    fi
fi
