url="wttr.in/Manchester?format=1"
curl $url -s | awk '{print $2}'
