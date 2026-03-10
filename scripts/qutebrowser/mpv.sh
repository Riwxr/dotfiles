#!/usr/bin/env bash

URL="$1"
blank=$(printf "\n ")
date=$(date +"%I:%M - %d-%b-%Y")
device=$(iwgetid -r)

if [[ "$URL" == *"watch?v="* ]] || [[ $URL == *"https://youtu.be/"* ]]; then

    notify-send "  MPV $blank" "loading-url..."
    echo " $date $URL" >>~/.cache/mpv-his.log
    if [[ "$device" == "Riwxr" ]]; then
        mpv --ytdl-raw-options=cookies=~/yt-cookies.txt --ytdl-format="best[height<=240]/best[height<=360]/best" --force-window "$URL" &
        MPV_PID=$!
        sleep 30 && ~/scripts/mpv_window_sorting.sh
        wait $MPV_PID
        ~/scripts/mpv_window_jankryyy.sh
    else
        mpv --ytdl-raw-options=cookies=~/yt-cookies.txt --ytdl-format="bestvideo[height<=480][vcodec^=av01]+bestaudio/best[height<=480]" --force-window "$URL" &
        MPV_PID=$!
        sleep 30 && ~/scripts/mpv_window_sorting.sh
        wait $MPV_PID
        ~/scripts/mpv_window_jankryyy.sh
    fi

else
    notify-send "  MPV $blank" "Argument does not contain a YouTube watch URL" -a toss
    exit 1
fi
