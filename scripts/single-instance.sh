#! /usr/bin/env bash

x=$1

if [[ $x = zen ]]; then
    list=$(hyprctl -j clients | jq -r '.[].class' | sort -u | grep "zen")

    if [[ -n $list ]]; then
        hyprctl dispatch focuswindow class:zen
    else
        zen-browser
    fi

elif [[ $x = lutris ]]; then
    list=$(hyprctl -j clients | jq -r '.[].class' | sort -u | grep "net.lutris.Lutris")

    if [[ -n $list ]]; then
        hyprctl dispatch focuswindow class:net.lutris.Lutris
    else
        play ~/sound/notification.wav &
        lutris
    fi

elif [[ $x = qutebrowser ]]; then
    list=$(hyprctl -j clients | jq -r '.[].class' | sort -u | grep "org.qutebrowser.qutebrowser")

    if [[ -n $list ]]; then
        hyprctl dispatch focuswindow class:org.qutebrowser.qutebrowser
    else
        qutebrowser
    fi

elif [[ $x = firefox ]]; then
    list=$(hyprctl -j clients | jq -r '.[].class' | sort -u | grep "firefox")

    if [[ -n $list ]]; then
        hyprctl dispatch focuswindow class:firefox
    else
        firefox
    fi

elif [[ $x = floorp ]]; then
    list=$(hyprctl -j clients | jq -r '.[].class' | sort -u | grep "microsoft-edge")

    if [[ -n $list ]]; then
        hyprctl dispatch focuswindow class:microsoft-edge
    else
        floorp
    fi

elif [[ $x = librawolf ]]; then
    list=$(hyprctl -j clients | jq -r '.[].class' | sort -u | grep "microsoft-edge")

    if [[ -n $list ]]; then
        hyprctl dispatch focuswindow class:microsoft-edge
    else
        librawolf
    fi

elif [[ $x = edge ]]; then
    list=$(hyprctl -j clients | jq -r '.[].class' | sort -u | grep "microsoft-edge")

    if [[ -n $list ]]; then
        hyprctl dispatch focuswindow class:microsoft-edge
    else
        microsoft-edge-stable
    fi
fi
