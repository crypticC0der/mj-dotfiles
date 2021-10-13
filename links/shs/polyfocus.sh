if [ $1 -ge 1440 ] && [ $1 -le 3360 ];then
	xprop -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY 0xffffffff -name "polybar_main"	
else
	xprop -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY 0xcccccccc -name "polybar_main"	
fi
