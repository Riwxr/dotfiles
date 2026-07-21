#!/usr/bin/env bash

state=$(cat ~/.local/statedablu.log)
if [[ state -eq 0 ]]; then
    ydotool key 17:1
    echo "1" >~/.local/statedablu.log
elif [[ state -eq 1 ]]; then
    ydotool key 17:0
    echo "0" >~/.local/statedablu.log
else
    quit
fi
