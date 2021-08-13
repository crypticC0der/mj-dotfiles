if [ -n "$(xprop -root | grep '_NET_CURRENT_DESKTOP(CARDINAL) = 0')" ];then
	xprop -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY 0xffffffff -name "polybar_main"	
else
	xprop -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY 0xcccccccc -name "polybar_main"	
fi
