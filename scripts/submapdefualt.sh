#!/usr/bin/env bash
mmsg -d setkeymode,default && echo "" >~/.local/submap.log
play ~/sound/notification-2.wav &
notify-send -a toss "Mango" "Default Mode"
