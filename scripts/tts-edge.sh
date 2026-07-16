#!/usr/bin/env bash
lastPID=$(cat ~/.local/ttsedge.log)
# kill $lastPID
pkill mpv
voice2="en-US-AvaNeural"
voice1="en-GB-RyanNeural"
blank=$(printf "\n ")

text=${1:-$(wl-paste --primary)}

[[ -z "$text" ]] && notify-send "󰔋  TTS $blank" "No Input." -u low && exit 0

id=1
notify-send --replace-id=$id "󰔊  TTS $blank" "TTS Starting" -t 6000 -u low

# trap "notify-send "󰔋 TTS $blank" "TTS killed" --replace-id=1 ; exit 130" SIGINT SIGTERM

state=$(playerctl -a status)

edge-tts --voice "$voice2" --text "$text" | mpv --config-dir="$HOME/.config/mpv-tts" - &
PID=$!
echo "$PID" >~/.local/ttsedge.log

wait $PID
status=$?

if [[ $status -eq 0 ]]; then
    notify-send --replace-id=$id "󰔊  TTS $blank" "TTS Complete." -a toss -u low
    rm -f /tmp/tts_ouput.txt
else
    notify-send --replace-id=$id "󰔋  TTS $blank" "TTS Failed" -u low
    exit 130
fi
if [[ $state == Playing ]]; then
    playerctl -a play
fi
