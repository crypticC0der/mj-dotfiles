cd ~/Documents/Programming/python/spotifyshortcuts
source ~/.spotclientpy
python3 spot.py dpout "$(source ~/.spotclientpy; python3 spot.py dpin | rofi -matching normal -font "hack 9" -dmenu -i -p "playlist")"
rm .tempcache
