#!/usr/bin/env bash

swayosd-client --custom-message "Opening"

engine=$(printf "Google\nChatgpt\nYouTube" | walker -d --minheight 1 -p "Search")
if [[ -n "$engine" ]]; then
    if [[ "$engine" == Google ]]; then
        query=$(printf "" | walker -d --minheight 1 -I -p "Google")
        [[ -n "$query" ]] && Url="https://www.google.com/search?q=$query"
    elif [[ "$engine" == Chatgpt ]]; then
        query=$(printf "" | walker -d --minheight 1 -p "Chatgpt" -I)
        [[ -n "$query" ]] && Url="https://chatgpt.com/?prompt=$query"
    elif [[ "$engine" == YouTube ]]; then
        query=$(printf "" | walker -d --minheight 1 -p "YouTube" -I)
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
