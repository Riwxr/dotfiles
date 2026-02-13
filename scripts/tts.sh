#!/usr/bin/env bash
blank=$(printf "\n ")

text=${1:-$(wl-paste --primary)} 

[[ -z "$text" ]] && notify-send "󰔋  TTS $blank" "No Input." -u low && exit 0

echo "$text" > /tmp/tts_input.txt

tr -cd '\11\12\15\40-\176' < /tmp/tts_input.txt > /tmp/tts_input_clean.txt

word=$(wc -w /tmp/tts_input_clean.txt | awk '{print $1}')

[[ $word == 0 ]] && notify-send "󰔋  TTS $blank" "No Readable Input." -u low && exit 0

id=$(notify-send -p "󰔊  TTS $blank" "TTS Starting   |   "$word" - words." -t 6000 -u low)

trap 'notify-send "󰔋  TTS $blank" "TTS killed" --replace-id=$id ; exit 130' SIGINT SIGTERM

kokoro-tts /tmp/tts_input_clean.txt /tmp/tts_output.wav --speed 1.6 --lang en-us --voice "af_river:20,af_sarah:80" --stream

status=$?

if [[ $status -eq 0 ]]; then
  	notify-send --replace-id=$id "󰔊  TTS $blank" "TTS Complete." -u low
#  paplay
else
	notify-send "󰔋  TTS $blank" "TTS Failed" --replace-id=$id -u low ; exit 130
fi


