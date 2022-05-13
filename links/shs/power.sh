#head -1 | awk '{print $2}'
a="$(upower --dump | grep percentage)"
if [ -n "$(echo $a | awk '{print $3}')" ]; then
	echo " $(echo $a | awk '{print $2}')"
fi
