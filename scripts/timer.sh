#!/usr/bin/env bash
shopt -s extglob

x=$1

if [[ $x == *[!0-9smhSMH]* ]]; then
    echo "contains stuff other then 0-9 and smh SMH" && exit 2
fi

num=${x//[^0-9]/}

case $x in
*[sS]) a=$num ;;
*[mM]) a=$((num * 60)) ;;
*[hH]) a=$((num * 3600)) ;;
*)
    if [[ $x == +([0-9]) ]]; then
        a=$x
    else
        exit 2
    fi
    ;;
esac

blank=$(printf "\n ")
printf -v t "%02d:%02d:%02d" $((a / 3600)) $(((a % 3600) / 60)) $((a % 60))

id=$(notify-send -p "󰔟 Timer $blank" "Timer started for $t" -a "toss")

for ((i = a; i >= 0; i--)); do
    if [[ $i -eq 0 ]]; then
        d=$(notify-send --replace-id="$id" "󱦟 Timer $blank" "Time Over Powering Off in 10 sec" -A "stop?" -t 10000)
        if [[ $d == 0 ]]; then
            exit 0
        else
            playerctl pause
            mpc stop
            wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
            systemctl poweroff
        fi
    elif ((i < 180)); then
        printf -v t "%02d:%02d:%02d" $((i / 3600)) $(((i % 3600) / 60)) $((i % 60))
        notify-send --replace-id="$id" -a "toss" "󰔟 Timer $blank" "Time Left $t"

    elif ((i % 300 == 0)); then
        printf -v t "%02d:%02d:%02d" $((i / 3600)) $(((i % 3600) / 60)) $((i % 60))
        notify-send --replace-id="$id" -a "toss" "󰔟 Timer $blank" "Time Left $t"
    fi

    sleep 1
done
