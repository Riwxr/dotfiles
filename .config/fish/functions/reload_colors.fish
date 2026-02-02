function reload_colors
    set_color $fish_color_keyword -o
    cat ~/banner.txt
    echo " "
    set_color normal

    set -U fish_greeting " "

    source ~/.cache/wal/colors.fish
    kitty @ set-colors --all ~/.cache/wal/colors-kitty.conf >/dev/null 2>&1
end
