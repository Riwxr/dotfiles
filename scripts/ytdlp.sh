#!/usr/bin/env bash
blank=$(printf "\n ")

links=(
"https://music.youtube.com/playlist?list=PL3_wNalDIHcJQ6Q1lLDqdyvKd7hL8Inr4&si=VHOL4hncWFkG8FvM"
"https://music.youtube.com/playlist?list=PLT-HHuSJ4y7TH9C-nwqcwZT-wo7V9-85T&si=FLd6qY3rpf-zMNkg"
"https://music.youtube.com/playlist?list=PLT-HHuSJ4y7RtSijitOnvW6jbAz4FWaRr&si=jleQnVSHtYL0StEH"
"https://music.youtube.com/playlist?list=PLT-HHuSJ4y7QyXbEiXb9c0jDC1MwbIB6A&si=Jrvm_gRD_x2J6GZK"
"https://music.youtube.com/playlist?list=PLT-HHuSJ4y7SnfJfBhUPgTvgVUI84NngL&si=2yhs8jxS2ApbXDFH"
"https://music.youtube.com/playlist?list=PLT-HHuSJ4y7SuqTlOoTe5Lp3bUIBlcRer&si=-idmHW6wJJ7rxCfP"
"https://music.youtube.com/playlist?list=PLT-HHuSJ4y7RC1mLU3dNo5hVBGjUsCe49&si=Mas6_9si7iAYZoHT"
"https://music.youtube.com/playlist?list=PL3_wNalDIHcJR4c9CH2zvMxShLYIGG2yP&si=qTc7H8jdglv_VctG"
"https://music.youtube.com/playlist?list=PLT-HHuSJ4y7QuyJw5Ow2nAv-xY2Bv7pxr&si=rQXq6esHLydUCWIt"
)

notify-send "  YT-DLP $blank" "Starting..."
for link in ${links[@]}; do
	~/scripts/ytdlp_extanded.sh $link
done

notify-send "  YT-DLP $blank" "Done"
