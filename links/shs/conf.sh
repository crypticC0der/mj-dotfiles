inp=$@
if [ "$inp" == "" ]; then
	fnam=$((cd ~/.config; find . -maxdepth 2 -type f | cut -c 3-) | fzf -e +s +m --height 10);
else
	fnam=$((cd ~/.config; find . -maxdepth 2 -type f | cut -c 3-) | fzf -1 -0 -e +s +m --height 10 -q "$@");
fi
if [ "$fnam" != "" ]; then
	(cd ~/.config; nvim $fnam)
fi
