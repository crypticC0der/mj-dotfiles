while true; do
	if [ $(playerctl metadata artist | wc -c ) != 1 ]; then
		if [ $(grep -i "$(playerctl metadata artist)" ~/.banned | wc -l) != 0 ] || [ $(grep "$(playerctl metadata title)" ~/.sbanned -i | wc -l) != 0 ]; then
		playerctl next;
		fi
	fi
	sleep 1;
done
