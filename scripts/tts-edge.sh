#!/usr/bin/env bash
blank=$(printf "\n ")

text=${1:-$(wl-paste --primary)}

[[ -z "$text" ]] && notify-send "󰔋  TTS $blank" "No Input." -u low && exit 0

id=$(notify-send -p "󰔊  TTS $blank" "TTS Starting" -t 6000 -u low)

trap 'notify-send "󰔋  TTS $blank" "TTS killed" --replace-id=$id ; exit 130' SIGINT SIGTERM

edge-tts --voice "en-US-AvaNeural" --text "$text" | mpv --no-config --speed=1.9 --volume=80 -

status=$?

if [[ $status -eq 0 ]]; then
    notify-send --replace-id=$id "󰔊  TTS $blank" "TTS Complete." -u low
    rm -f /tmp/tts_ouput.txt
else
    notify-send "󰔋  TTS $blank" "TTS Failed" --replace-id=$id -u low
    exit 130
fi
