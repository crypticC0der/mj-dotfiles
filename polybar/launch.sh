#!/usr/bin/env bash

# Add this script to your wm startup file.

fc-cache -f
# Terminate already running bar instances
pkill polybar

# Launch the bar
polybar main 
