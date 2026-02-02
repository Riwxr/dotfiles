#!/usr/bin/env bash

set -e

INPUT="$HOME/.cache/test.txt"

words1="$1"
words2="$2"

file1="/tmp/test1_${words1}.txt"
file2="/tmp/test2_${words2}.txt"

x=$(tr ' ' '\n' < "$INPUT" | head -n "$words1" | tr '\n' ' ')

if [ -n "$words2" ]; then
	total=$(( words1 + words2 ))
	y=$(tr ' ' '\n' < "$INPUT" | head -n "$total" | tail -n "$words2" | tr '\n' ' ')
fi

echo "---------------------------------------------------------------------------------"

echo "$x" > "$file1"
echo "$file1 created!"

if [ -n "$words2" ]; then
	echo "$y" > "$file2"
	echo "$file2 created!"
fi

echo "---------------------------------------------------------------------------------"
echo " word count is :-- "
wc "$file1"
[ -n "$words2" ] && wc "$file2"
echo "---------------------------------------------------------------------------------"

if [ -z "$words2" ]; then
	kokoro-tts "$file1" /tmp/tts_test_output1.wav --speed 1.4 --lang en-us --voice "af_river:20,af_sarah:80"
else
	kokoro-tts "$file1" /tmp/tts_test_output1.wav --speed 1.4 --lang en-us --voice "af_river:20,af_sarah:80" &
	kokoro-tts "$file2" /tmp/tts_test_output2.wav --speed 1.4 --lang en-us --voice "af_river:20,af_sarah:80"
	wait
fi

echo "---------------------------------------------------------------------------------"

play /tmp/tts_test_output1.wav && [ -n "$words2" ] && play /tmp/tts_test_output2.wav

echo "---------------------------------------------------------------------------------"

rm -f "$file1" /tmp/tts_test_output1.wav
echo "$file1 /tmp/tts_test_output1.wav REMOVED"

if [ -n "$words2" ]; then
	rm -f "$file2" /tmp/tts_test_output2.wav
	echo "$file2 /tmp/tts_test_output2.wav REMOVED"
fi

