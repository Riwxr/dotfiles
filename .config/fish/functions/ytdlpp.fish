function ytdlpp
    yt-dlp -n -f bestaudio \
        --extract-audio --audio-format mp3 \
        --embed-thumbnail --add-metadata --yes-playlist \
        -o '~/Music/%(playlist_title)s/%(title)s.%(ext)s' \
        $argv
end

