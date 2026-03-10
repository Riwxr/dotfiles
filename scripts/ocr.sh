#!/usr/bin/env bash
blank=$(printf "\n ")

rm /tmp/tmp-ocr-image.png
rm /tmp/tmp-ocr-text.txt

flameshot gui -p /tmp/tmp-ocr-image.png
id=$(notify-send -p "󰮄  Tesseract $blank" "󰆨  Scanning..." -a repeat)

tesseract /tmp/tmp-ocr-image.png /tmp/tmp-ocr-text

x=$(cat /tmp/tmp-ocr-text.txt)

if [ -s /tmp/tmp-ocr-text.txt ]; then
    wl-copy "$x"
    z=$(notify-send --replace-id=$id "󰮄  Tesseract $blank" "Output : $blank $blank $x" -A 'Open in Editor')
    [[ $z == 0 ]] && foot --app-id "ocr-editor" nvim -n /tmp/tmp-ocr-text.txt && rm /tmp/tmp-ocr-image.png && rm /tmp/tmp-ocr-text.txt
else
    notify-send --replace-id=$id "󰮄  Tesseract $blank" "󱐝  No Output"
fi
