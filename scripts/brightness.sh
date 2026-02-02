#!/bin/bash

FILE="$HOME/.config/quickshell/quickshell-examples-master/activate_linux/shell.qml"
STEP=0.10
MIN=0.0
MAX=0.9

# Extract current opacity
CURRENT=$(awk '
    /property real opacity:/ {
        print $NF
        exit
    }
' "$FILE")

# If not found or invalid, abort
[[ -z "$CURRENT" ]] && exit 1

clamp() {
    awk -v v="$1" -v min="$MIN" -v max="$MAX" '
        BEGIN {
            if (v < min) v = min
            if (v > max) v = max
            printf "%.2f", v
        }
    '
}

case "$1" in
    up)
        NEW=$(awk -v c="$CURRENT" -v s="$STEP" 'BEGIN { printf "%.4f", c + s }')
        NEW=$(clamp "$NEW")
        ;;
    down)
        NEW=$(awk -v c="$CURRENT" -v s="$STEP" 'BEGIN { printf "%.4f", c - s }')
        NEW=$(clamp "$NEW")
        ;;
    *)
        # Direct numeric input
        if [[ "$1" =~ ^[0-9]*\.?[0-9]+$ ]]; then
            NEW=$(clamp "$1")
        else
            exit 0
        fi
        ;;
esac

# Final safety: ensure NEW is a number
[[ ! "$NEW" =~ ^[0-9]*\.?[0-9]+$ ]] && exit 1

# Replace safely
sed -i "s/\(property real opacity:\s*\)[0-9.]\+/\1$NEW/" "$FILE"

swayosd-client --custom-message "Opacity set to $NEW"

