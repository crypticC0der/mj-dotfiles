cd /home/mj/.local/share/Steam/appcache/librarycache
x=$(ls *icon* -1);
for i in $x;
do cp $i /home/mj/.local/share/icons/hicolor/32x32/apps/steam_icon_$(echo $i | rev | cut -c 10- | rev).png;
done;
