
alias zz='~/scripts/zz.sh'

# Todo done 
alias x='todo done'

# Todo add
alias +='todo new'

# Alias for MP3 audio download
alias ytmp3='yt-dlp -x --audio-format mp3 -o "~/Downloads/ytdlp/music/%(title)s.%(ext)s"'

# Alias for full video download
alias ytdlp='yt-dlp -o "~/Downloads/ytdlp/%(title)s.%(ext)s"'

# Alias for full ytm playlist
alias ytmdlp-list='yt-dlp -f bestaudio --extract-audio --audio-format mp3 --embed-thumbnail --add-metadata --yes-playlist -o "~/Music/%(playlist)s/%(title)s.%(ext)s"'


