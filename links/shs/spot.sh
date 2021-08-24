cd ~/Documents/Programming/python/spotifyshortcuts
python3 spot.py dout "$(python3 spot.py din | tac | rofi -font "hack 9" -multi-select -matching normal -dmenu -i -p "song")"
