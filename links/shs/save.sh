imgpath=~/Pictures/screenshots/"$(date +'%Y-%m-%d-%T').png"
maim -s -u $imgpath
notify-send "image saved at $imgpath"
echo "$imgpath" | xclip -i -selection clipboard
