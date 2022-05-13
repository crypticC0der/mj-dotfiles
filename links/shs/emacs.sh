if [ -z "$(pgrep emacs)" ];then
	emacs 
else
	emacsclient -c 
fi
