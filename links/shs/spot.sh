source ~/.spotclientpy
cd ~/Documents/Programming/python/spotifyshortcuts
o="$(python3 spot.py din | tac | rofi -font "hack 9" -multi-select -matching normal -dmenu -i -p "song")"
if [ "$1" == "shuffle" ]; then
    python3 spot.py douts "$o"
else
    python3 spot.py dout "$o"
fi
