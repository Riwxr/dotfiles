#!/usr/bin/env bash

while true; do
    HIST="$HOME/.cache/fzffilehist.log"
    LIST="$HOME/.cache/fzffilelist.log"

    blank=$(printf "\n ")
    shebang="#!/usr/bin/env bash\n\n\n"

    logging() {
        # remove file if its already there
        sed -i "\|$1|d" $HIST
        # Append file to hist
        Logexisting=$(cat $HIST)
        echo "$1" >"$HIST"
        echo "$Logexisting" >>"$HIST"
    }

    # log files
    find $HOME/dotfiles/scripts/ $HOME/dotfiles/.config/ \
        -type f | sed "s|$HOME/dotfiles/||" >$LIST
    echo "\`[new file]" >>$LIST

    # fzf pool list and hist
    chosen=$(awk '!seen[$0]++ && $0!=""' $HIST $LIST | fzf -i)

    if [ -z "$chosen" ]; then
        /usr/local/bin/hyprscratch fzfscripts hide
    elif [[ $chosen == "\`[new file]" ]]; then
        filename=scripts/$(echo "" | fzf --print-query --prompt="Filename : ").sh
        filepath=/home/riwxr/dotfiles/$filename
        if [ -e $filepath ]; then
            notify-send "Task failed $blank" "file already exist, openning existing file"
            setsid foot --title "$filepath" nvim +3 +startinsert "$filepath" >/dev/null 2>&1 &
        elif [[ $filepath = "/home/riwxr/dotfiles/scripts/x.sh" ]]; then
            notify-send "Closed"
        else
            touch $filepath
            printf "$shebang" >>$filepath
            chmod +x $filepath
            logging $filename
            setsid foot --title "$filepath" nvim +3 +startinsert "$filepath" >/dev/null 2>&1 &
        fi

        /usr/local/bin/hyprscratch fzfscripts hide
    else

        logging $chosen
        chosenfull=$HOME/$chosen
        if $(hyprctl -j clients | jq -r '.[].title' | grep -Fx "$chosenfull" >/dev/null); then
            notify-send "Task failed $blank" "file already open"
            /usr/local/bin/hyprscratch fzfscripts hide
        else
            setsid foot --title "$chosenfull" nvim "$chosenfull" >/dev/null 2>&1 &
            /usr/local/bin/hyprscratch fzfscripts hide
        fi
    fi
done
