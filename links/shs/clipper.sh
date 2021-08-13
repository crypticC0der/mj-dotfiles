#!/bin/bash
#test if jpg
jpg=$(echo "$QUTE_URL" | grep "\.jp.*g")

if [ -z "$jpg" ];then
	#handle pngs
	curl "$QUTE_URL" | xclip -selection clipboard -t image/png -i
else
	#handle jpgs
	curl "$QUTE_URL" > /tmp/img.jpg;
	mogrify -format png /tmp/img.jpg;
	xclip -selection clipboard -t image/png -i /tmp/img.png;
fi
