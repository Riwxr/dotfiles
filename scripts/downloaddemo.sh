#!/usr/bin/env bash
blank=$(printf "\n ")

emptybar="░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
pro() {
	local percent=$1
	local replacement="█████████████████████████████████████"
	local X=${#emptybar}
	local N=$(( X * percent / 100 ))
	local remaining="${emptybar:N}"
	local added="${replacement:0:N}"
	bar=$added$remaining
}


id=$(notify-send -p "Downloding $blank" " 0% : $emptybar")

for i in {1..100}; do
  echo "$i"
  pro $i
  if [[ $i == 100 ]]; then
	  notify-send --replace-id $id "Downloaded $blank" " $i% : $blank$bar" 
  else
	  notify-send --replace-id $id -a repeat "Downloding $blank" " $i% : $blank$bar"  
  
  fi
  sleep .1
done


