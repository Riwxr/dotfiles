#!/usr/bin/env bash

engine=$(printf "Google\nChatgpt\nYt" | rofi -dmenu -l 3 -theme-str 'entry { placeholder: "seach"; placeholder-color: grey;}' -show combi -p "Engine : ")
if [[ -n "$engine" ]]; then
    if [[ "$engine" == Google ]]; then
        query=$(printf "" | rofi -dmenu -l 3 -theme-str 'entry { placeholder: "seach"; placeholder-color: grey;}' -show combi -p "$engine : ")
        [[ -n "$query" ]] && Url="https://www.google.com/search?q=$query"
    elif [[ "$engine" == Chatgpt ]]; then
        query=$(printf "" | rofi -dmenu -l 3 -theme-str 'entry { placeholder: "seach"; placeholder-color: grey;}' -show combi -p "$engine : ")
        [[ -n "$query" ]] && Url="https://chatgpt.com/?prompt=$query"
    elif [[ "$engine" == Yt ]]; then
        query=$(printf "" | rofi -dmenu -l 3 -theme-str 'entry { placeholder: "seach"; placeholder-color: grey;}' -show combi -p "$engine : ")
        [[ -n "$query" ]] && Url="https://www.youtube.com/results?search_query=$query"
    else
        Url="https://www.google.com/search?q=$engine"
    fi

fi
if [[ -n "$Url" ]]; then
    qutebrowser "$Url"
    sleep 0.2
    hyprctl dispatch focuswindow class:org.qutebrowser.qutebrowser >/dev/null
fi
