#!/bin/bash
#test if jpg
jpg=$(echo "$@" | grep "\.jp.*g")

if [ -z "$jpg" ];then
	#handle pngs
	curl "$@" | xclip -selection clipboard -t image/png -i
else
	#handle jpgs
	curl "$@" > /tmp/img.jpg;
	mogrify -format png /tmp/img.jpg;
	xclip -selection clipboard -t image/png -i /tmp/img.png;
fi
