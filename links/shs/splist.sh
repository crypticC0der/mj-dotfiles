cd ~/Documents/Programming/python/spotifyshortcuts
python3 spot.py dpout "$(python3 spot.py dpin | rofi -matching normal -dmenu -i -p "playlist")"
rm .cache

