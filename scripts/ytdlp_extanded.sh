#!/usr/bin/env bash

json_dump=/tmp/ytdlp_playlist.txt
url_playlist=$1
verbose=$2
blank=$(printf "\n ")

yt-dlp --flat-playlist --print-json "$url_playlist" >$json_dump

playlist=$(cat $json_dump | jq -r '.playlist_title' | sort -u)
dir=$HOME/Music/"$playlist"

if [[ ! -d "$dir" ]]; then
    mkdir $dir
fi

total=$(cat /tmp/ytdlp_playlist.txt | jq -r '.n_entries' | sort -u)
existing=$(ls -1 ~/Music/"$playlist"/ | wc -l)
pending=$((total - existing))
heading="  YT-DLP  - $playlist"

echo "playlist=[$playlist]"
echo "total=[$total]"
echo "existing=[$existing]"
echo "pending=[$pending]"

if [[ verbose -eq 0 ]]; then

    if [[ $pending -eq 0 ]]; then
        id=$(notify-send -p "$heading$blank" "$pending - New Songs   (tho gonna try)")
    elif [[ $pending -lt 0 ]]; then
        id=$(notify-send -p "$heading$blank" "$pending - New Songs...   (somethin aint right)")
    else
        id=$(notify-send -p "$heading$blank" "$pending - New Songs")
    fi

fi

mapfile -t titles < <(cat $json_dump | jq -r '.title')
mapfile -t urls < <(jq -r '.id | "https://youtu.be/" + .' "$json_dump")
count=0
for i in "${!titles[@]}"; do
    title="${titles[i]}"
    url="${urls[i]}"
    dir="$HOME/Music/"$playlist"/"

    fullpath=""$dir""$title".mp3"

    if [[ -e "$fullpath" ]]; then
        echo "$i"

    elif [[ $title =~ [^a-zA-Z0-9._\ -] ]]; then
        trimmed="${title%%[^a-zA-Z0-9._ -]*}"
        if compgen -G "$dir$trimmed"* >/dev/null; then
            echo "✅ exists - via trimmed match"
        else
            echo "❌ not found, need download"
            if [[ verbose -eq 0 ]]; then
                ~/scripts/downloaddemo.sh $count $pending "$heading" "$title" $id
            fi
            yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --embed-metadata --embed-thumbnail -o "$dir/%(title)s.%(ext)s" "$url"
            ((count++))
            if [[ verbose -eq 0 ]]; then
                ~/scripts/downloaddemo.sh $count $pending "$heading" "$title" $id
            fi
        fi
    else
        echo "❌ prolly dont exists"
        if [[ verbose -eq 0 ]]; then
            ~/scripts/downloaddemo.sh $count $pending "$heading" "$title" $id
        fi
        yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --embed-metadata --embed-thumbnail -o "$HOME/Music/"$playlist"/%(title)s.%(ext)s" "$url"
        ((count++))
        if [[ verbose -eq 0 ]]; then
            ~/scripts/downloaddemo.sh $count $pending "$heading" "$title" $id
        fi
    fi
done
