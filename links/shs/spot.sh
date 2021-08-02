cd ~/Documents/Programming/python/spotifyshortcuts
python3 spot.py dout "$(python3 spot.py din | tac | rofi -multi-select -matching normal -dmenu -i -p "song")"
