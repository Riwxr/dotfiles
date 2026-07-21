#! /usr/bin/env bash

state=$(cat ~/.local/stateF9.log)

if [[ $state -eq 1 ]]; then
    ydotool key 67:0
    echo "0" >~/.local/stateF9.log
else
    ydotool key 67:1
    echo "1" >~/.local/stateF9.log
fi
