#! /usr/bin/env bash 

file=$(find ~/scripts \
~/.config/hypr \
~/.config/alacritty \
~/.config/fish \
~/.config/fastfetch \
~/.config/autostart \
~/.config/bat \
~/.config/flameshot \
~/.config/kitty \
~/.config/nvim \
~/.config/quickshell/quickshell-examples-master \
~/.config/quickshell/wayrep \
~/.config/rmpc \
~/.config/rofi \
~/.config/swayosd \
~/.config/waybar \
~/.config/yazi \
~/.config/zathura \
| fzf -i) || exit

touch ~/.cache/file_usage.log


hyprctl dispatch settiled


file="$1"
echo "$(date +%s) $file" >> ~/.cache/file_usage.log
nvim "$file"


[ -n "$file" ] && nvim "$file"

