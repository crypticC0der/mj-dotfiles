cd ~/Documents/Programming/python/spotifyshortcuts
source ~/.spotclientpy
o=$(python3 spot.py playlisttracks "$(source ~/.spotclientpy; python3 spot.py dpin | rofi -matching normal -font "hack 9" -dmenu -i -p "playlist")" | tac ) 
if [ -n "$o" ];then
	o=$(echo "$o" | rofi -font "hack 9" -multi-select -matching normal -dmenu -i -p "song")
	python3 spot.py playtro "$o"
fi
rm .currentplaylist
rm .tempcache
