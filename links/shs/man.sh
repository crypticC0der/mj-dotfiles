#!/bin/bash
alacritty -e man $(for i in {1..8}; do \ls -1 "/usr/share/man/man$i"; done | rev | cut -c 6- | rev | awk 'length<=20'| dmenu -p "man:")
