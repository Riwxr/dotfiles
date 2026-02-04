#!/usr/bin/env bash

a=$1
id=$(notify-send -p "󰔟 Timer $blank" "Timer started for $a sec" -a "toss")

for ((i=a; i>=0; i--)); do
    if [[ $i -eq 0 ]]; then
        notify-send --replace-id="$id" "󱦟 Timer $blank" "Time Over 00:00"
    else
        printf -v t "%02d" "$i"
        notify-send --replace-id="$id" -a "toss" "󰔟 Timer $blank" "Time Left 00:$t"
    fi
    sleep 1
done

