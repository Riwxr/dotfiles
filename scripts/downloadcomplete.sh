#! /usr/bin/env bash
FILE_PATH="$1"
FILE_NAME=$(basename "$FILE_PATH")
text=$(printf " FDM\n$FILE_NAME - Downloaded")

tnotify "$text"
notify-send "FDM Download Complete" "Downloaded - $FILE_NAME"

dt=$(date)

echo "$dt - $FILE_PATH - $FILE_NAME" >>~/.local/share/downloading.log
