#!/usr/bin/env bash

file=~/vimwiki/Todo.md
donefile=~/vimwiki/Done.md
blank=$(printf "\n ")

touch "$file" "$donefile"
hyprctl dispatch focuswindow class:fzftodoadd > /dev/null


append() {
    echo "* [ ] $1" >> "$file"
    echo "\"$1\" - added!"
    notify-send "  Todo $blank" "\"$1\" - added!"
}

check() {
    local task="$1"
    # remove only the first matching unchecked task
    sed -i "/^\* \[ \] $task$/d" "$file"
    echo "  "$task"" >> "$donefile"
    echo "\"$task\" - completed!"
    notify-send "  Todo $blank" "\"$task\" - completed!"
}


# fzf: first line is query, second line (if any) is selection
while true; do

	tasks=$(grep -E '^\* \[ \] ' "$file" | sed 's/^\* \[ \] //')

	out=$(printf "  Exit\n  Addd\n$tasks" | fzf --print-query --prompt="[ ] ")

	if [[ "$out" == *$'\n  Addd' ]]; then
		out=$(printf "" | fzf --print-query --prompt="[ ] ")
	elif [[ "$out" == *$'\n  Exit' ]]; then
		exit 0
	fi

	query=$(printf "%s" "$out" | sed -n '1p')
	selected=$(printf "%s" "$out" | sed -n '2p')

	if [[ -n "$selected" ]]; then
	    # user selected existing task
	    check "$selected"
	elif [[ -n "$query" ]]; then
	    # user typed new task
	    append "$query"
	fi

done
