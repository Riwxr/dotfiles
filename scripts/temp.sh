#!/usr/bin/env bash

SRC="Downloads/PkgTTF-Iosevka-33.3.6"
DEST="OhMyFont/CFI"

mkdir -p "$DEST"

declare -A MAP

# Upright
MAP["ur.ttf"]="Iosevka-Regular.ttf"
MAP["um.ttf"]="Iosevka-Medium.ttf"
MAP["ub.ttf"]="Iosevka-Bold.ttf"
MAP["usb.ttf"]="Iosevka-SemiBold.ttf"
MAP["ul.ttf"]="Iosevka-Light.ttf"
MAP["uel.ttf"]="Iosevka-ExtraLight.ttf"
MAP["ut.ttf"]="Iosevka-Thin.ttf"
MAP["ueb.ttf"]="Iosevka-ExtraBold.ttf"
MAP["ubl.ttf"]="Iosevka-Heavy.ttf"   # closest to Black

# Italics
MAP["ir.ttf"]="Iosevka-Italic.ttf"
MAP["im.ttf"]="Iosevka-MediumItalic.ttf"
MAP["ib.ttf"]="Iosevka-BoldItalic.ttf"
MAP["isb.ttf"]="Iosevka-SemiBoldItalic.ttf"
MAP["il.ttf"]="Iosevka-LightItalic.ttf"
MAP["iel.ttf"]="Iosevka-ExtraLightItalic.ttf"
MAP["it.ttf"]="Iosevka-ThinItalic.ttf"
MAP["ieb.ttf"]="Iosevka-ExtraBoldItalic.ttf"
MAP["ibl.ttf"]="Iosevka-HeavyItalic.ttf" # closest to BlackItalic

for target in "${!MAP[@]}"; do
    src_file="$SRC/${MAP[$target]}"
    if [[ -f "$src_file" ]]; then
        cp "$src_file" "$DEST/$target"
        echo "→ $target from ${MAP[$target]}"
    else
        echo "Missing: ${MAP[$target]}"
    fi
done

echo "Done. Now flash CFI."

