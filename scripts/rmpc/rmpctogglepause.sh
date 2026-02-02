
#!/usr/bin/env bash

rmpc togglepause

s="$(rmpc song | jq -r '.metadata.title')"
st="$(rmpc status | jq -r '.state')"

[ -z "$s" ] && s="No song"

case "$st" in
    Play) icon="" ;;
    Pause) icon="" ;;
    Stop) icon="" ;;
    *) icon="" ;;
esac

swayosd-client --custom-message " $icon    -   $s "

