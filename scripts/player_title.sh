
#!/bin/bash

escape() {
    # Escape ALL markup-breaking characters
    printf '%s' "$1" \
    | sed -e 's/&/\&amp;/g' \
          -e 's/</\&lt;/g' \
          -e 's/>/\&gt;/g' \
          -e 's/"/\&quot;/g' \
          -e "s/'/\&#39;/g"
}

players=$(playerctl -l 2>/dev/null)
[ -z "$players" ] && echo "No Media" && exit 0

title="$(playerctl metadata title 2>/dev/null)"
[ -z "$title" ] && echo "no media" && exit 0

length=${#title}
if [ "$length" -gt 36 ]; then
    title="${title:0:36}_"
fi

escape "$title"

