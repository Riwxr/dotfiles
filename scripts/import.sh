#!/usr/bin/env bash

# Paths
PHONE_DIR="/sdcard/Camera/"
PC_DIR="$HOME/Downloads/DCIM/Camera/"

# Make sure local folder exists
mkdir -p "$PC_DIR"

# Temp files
LOCAL_LIST=$(mktemp)
DEVICE_LIST=$(mktemp)
MISSING_LIST=$(mktemp)

# List files on PC
ls "$PC_DIR" > "$LOCAL_LIST"

# List files on phone
adb shell "ls $PHONE_DIR" | tr -d '\r' > "$DEVICE_LIST"

# Find missing files (on phone but not on PC)
comm -23 <(sort "$DEVICE_LIST") <(sort "$LOCAL_LIST") > "$MISSING_LIST"

# Pull missing files
while read -r file; do
    [ -z "$file" ] && continue   # skip empty lines
    echo "Pulling: $file"
    adb pull "$PHONE_DIR$file" "$PC_DIR"
done < "$MISSING_LIST"

# Clean up
rm "$LOCAL_LIST" "$DEVICE_LIST" "$MISSING_LIST"

echo "Sync complete!"

