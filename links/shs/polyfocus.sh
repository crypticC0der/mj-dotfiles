if [ $1 -le 1920 ] && [ $2 -le 1080 ];then
	xprop -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY 0xffffffff -name "polybar_main"	
else
	xprop -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY 0xcccccccc -name "polybar_main"	
fi
