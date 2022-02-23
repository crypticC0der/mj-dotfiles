dunstctl set-paused true
i3lock -c 000000ff -S 1 --pass-media-keys --bar-indicator --bar-pos 1080 --bar-direction 1 -i ~/Documents/lock2.png \
		--greeter-font=hack --greeter-text="Oh hell no." --greeter-color=bd1864 --greeter-size=100 --greeter-pos="2425:760" \
		--verif-text="I'm checking..." --verif-color 00913c --verif-pos="2475:980" --verif-size=100 --verif-font=hack \
		--wrong-text="You seriously think it'd be that easy?" --wrong-color 930100 --wrong-pos="2425:980" --wrong-size=70 --wrong-font=hack \
		--modif-pos="2425:880" --modif-size=40 --modif-color 930100 \
		--noinput-text="" \
		--bar-periodic-step 6 --bar-step 15 --bar-max-height 30 --bshl-color=b14800 --keyhl-color=bb1762 --ringver-color 00913c --ringwrong-color="930100" -n 
dunstctl set-paused false
