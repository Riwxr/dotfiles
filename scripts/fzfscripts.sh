#!/usr/bin/env bash

HIST="$HOME/.cache/fzffilehist.log"
LIST="$HOME/.cache/fzffilelist.log"

blank=$(printf "\n ")
shebang="#!/usr/bin/env bash\n\n\n"

logging() {
	# remove file if its already there
	sed -i "\|$1|d" $HIST
	# Append file to hist
	Logexisting=$(cat $HIST)
	echo "$1" > "$HIST"
	echo "$Logexisting" >> "$HIST"
}

# log files
find ~/scripts \
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
~/.config/swaync \
~/.config/waybar \
~/.config/yazi \
~/.config/zathura \
-type f | sed "s|$HOME/||" > $LIST
echo "\`" >> $LIST


# fzf pool list and hist
chosen=$(awk '!seen[$0]++ && $0!=""' $HIST $LIST | fzf -i)

if [ -z "$chosen" ]; then
	exit 125
elif [[ $chosen == "\`" ]]; then
	filename=scripts/$(echo "" | fzf --print-query --prompt="Filename : ").sh	
	filepath=/home/riwxr/$filename
	if [ -e $filepath ]; then
		notify-send "Task failed $blank" "file already exist, openning existing file"		
	else
		touch $filepath
		printf "$shebang" >> $filepath
		chmod +x $filename
		logging $filename
	fi
	
	nohup kitty --title "$filepath" nvim +3 +startinsert "$filepath" >/dev/null 2>&1 &
	hyprctl dispatch killwindow class:fzfscripts
else

	logging $chosen
	chosenfull=$HOME/$chosen
	if $(hyprctl -j clients | jq -r '.[].title' | grep -Fx "$chosenfull" >/dev/null); then
		$chosenfull && sleep 60 
	else
		nohup kitty --title "$chosenfull" nvim "$chosenfull" >/dev/null 2>&1 &
		hyprctl dispatch killwindow class:fzfscripts
	fi
fi
