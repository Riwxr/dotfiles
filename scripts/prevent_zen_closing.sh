
#!/usr/bin/env bash

active_class=$(hyprctl activewindow -j | jq -r '.class')

if [ "$active_class" = "zen" ]; then
    msgs=(
        "NOPE."
        "Not Happenin LOSER."
        "That's it. Calm down."
        "UH-HUH."
        "You Shall NOT Pass Through Under My Watch."
        "I AM INVINSIDBLE. MORTAL"
        "Access denied."
        "NO."
        "I Am The Bane Of Your Existence! MUHAHHAHA!"
    )

    msg="${msgs[$RANDOM % ${#msgs[@]}]}"
    notify-send "$msg"

elif [ "$active_class" = "sleek" ]; then
    /usr/local/bin/hyprscratch sleek toggle

elif [ "$active_class" = "rmpc" ]; then
    /usr/local/bin/hyprscratch rmpc toggle

elif [ "$active_class" = "org.kde.kdeconnect.app" ]; then
    /usr/local/bin/hyprscratch "KDE Connect" toggle

else
    hyprctl dispatch killactive
fi

pkill -RTMIN+3 waybar
