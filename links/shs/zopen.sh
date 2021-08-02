#! /bin/bash
cd /tmp;
mkdir zopen;
cd zopen;
wget $(xclip -selection clipboard -o);
x="$(\ls -1t | head -1)";
zathura "$x" -P 1;
rm "$x";
