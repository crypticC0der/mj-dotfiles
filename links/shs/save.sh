imgpath=~/Pictures/screenshots/"$(date +'%Y-%m-%d-%T').png"
maim -s -u $imgpath
if [ -f "$imgpath" ]; then
	notify-send "image saved at $imgpath"
fi
echo "$imgpath" | xclip -i -r -selection clipboard
