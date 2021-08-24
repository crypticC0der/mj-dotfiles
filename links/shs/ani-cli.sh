#!/bin/sh

# dependencies: grep sed curl video_player awk fzf
# optional dependencies: trackma dmenu
# video_player ( needs to be able to play urls )
player_fn="mpv"
dmenu="no"
use_trackma="yes"
trackma_account_no=1

prog="ani-cli"
logfile="${XDG_CACHE_HOME:-$HOME/.cache}/ani-hsts"
trackmafile="${XDG_CACHE_HOME:-$HOME/.cache}/ani-trackma"

c_red="\033[1;31m"
c_green="\033[1;32m"
c_yellow="\033[1;33m"
c_blue="\033[1;34m"
c_magenta="\033[1;35m"
c_cyan="\033[1;36m"
c_reset="\033[0m"


help_text () {
	while IFS= read line; do
		printf "%s\n" "$line"
	done <<-EOF
	USAGE: $prog [OPTIONS] <query>
	 -h	 	Show this help text
	 -H	 	Continue where you left off
	 -s	 	Settings
	 -p [player]	Choose a player which can stream the episodes
	 -t [number]	Toggle trackma (1 for using and 0 for not using trackma)
	 -d [number]	Toggle dmenu (1 for using and 0 for not using dmenu)
	 -D	 	Download episode
	EOF
}


die () {
	printf "$c_red%s$c_reset\n" "$*" >&2
	exit 1
}

err () {
	printf "$c_red%s$c_reset\n" "$*" >&2
}

# Error when invalid argument is passed
wrong_args () {
	flag="$1"
	printf "${c_red}Invalid argument passed to -%s\n${c_reset}" "$flag" >&2
	help_text | grep -e "USAGE" -e "\-$flag"
	exit 1
}

search_anime () {
	# get anime name along with its id
	search=$1
	titlepattern='<a href="/category/'

	curl -s "https://gogoanime.vc//search.html" \
		-G \
		-d "keyword=$search" |
	sed -n -E '
		s_^[[:space:]]*<a href="/category/([^"]*)" title="([^"]*)".*_\1_p
		'
}

search_eps () {
	# get available episodes for anime_id
	anime_id=$1

	curl -s "https://gogoanime.vc/category/$anime_id" |
	sed -n -E '
		/^[[:space:]]*<a href="#" class="active" ep_start/{
		s/.* '\''([0-9]*)'\'' ep_end = '\''([0-9]*)'\''.*/\2/p
		q
		}
		'
}

get_links () {
	# get the download page url
	anime_id=$1
	ep_no=$2

	dpage_url=$(
	curl -s "https://gogoanime.vc/$anime_id-episode-$ep_no" |
	sed -n -E 's_^[[:space:]]*<a href="#" rel="100" data-video="([^"]*)" >.*_https:\1_p')

	curl -s "$dpage_url" |
	sed -n -E "s/^[[:space:]]*sources:\[\{file\: '([^']*)'.*/\1/p" | sed 1q
}

dep_ch () {
	for dep; do
		if ! command -v "$dep" >/dev/null ; then
			die "Program \"$dep\" not found. Please install it."
		fi
	done
}

# get query
get_search_query () {
	if [ -z "$*" ]; then
		if [ "$dmenu" = "yes" ]; then
			query=$(echo "" | dmenu -p "Search Anime: ")
		else
			printf "Search Anime: "
			read -r query
		fi
	else
		query=$*
	fi
}

# create history and trackma file
[ -f "$logfile" ] || : > "$logfile"
[ -f "$trackmafile" ] || : > "$trackmafile"

#####################
## Anime selection ##
#####################

anime_selection () {
	search_results=$*
	menu_format_string='[%d] %s\n'
	menu_format_string_c1="${c_blue}[$c_cyan%d$c_blue] $c_reset%s\n"
	menu_format_string_c2="${c_blue}[$c_cyan%d$c_blue] $c_yellow%s$c_reset\n"

	count=1
	while read anime_id; do
		# alternating colors for menu
		[ $((count % 2)) -eq 0 ] &&
			menu_format_string=$menu_format_string_c1 ||
			menu_format_string=$menu_format_string_c2

		printf "$menu_format_string" "$count" "$anime_id"
		count=$((count+1))
	done <<-EOF
	$search_results
	EOF

	# User input
	printf "$c_blue%s$c_green" "Enter number: "
	read choice
	printf "$c_reset"

	# Check if input is a number
	[ "$choice" -eq "$choice" ] 2>/dev/null || die "Invalid number entered"

	# Select respective anime_id
	count=1
	while read anime_id; do
		if [ $count -eq $choice ]; then
			selection_id=$anime_id
			break
		fi
		count=$((count+1))
	done <<-EOF
	$search_results
	EOF

	[ -z "$selection_id" ] && die "Invalid number entered"

	read last_ep_number <<-EOF
	$(search_eps "$selection_id")
	EOF
}

dmenu_anime_selection () {
	search_results=$*
	selection_id=$(echo "$search_results" | tr " " "\n" | dmenu -l 30)

	[ -z "$selection_id" ] && die "Nothing Selected."

	read last_ep_number <<-EOF
	$(search_eps "$selection_id")
	EOF
}

##################
## Ep selection ##
##################

episode_selection () {
	[ $is_download -eq 1 ] &&
		printf "Range of episodes can be specified: start_number end_number\n"

	printf "${c_blue}Choose episode ${c_cyan}[1-%d]$c_reset:$c_green " $last_ep_number
	read ep_choice_start ep_choice_end
	printf "$c_reset"

}

dmenu_episode_selection () {
	episode_choice=$(echo "" | dmenu -p "Choose episode [1-$last_ep_number]")
	ep_choice_start=$(echo "$episode_choice" | awk '{print $1}')
	ep_choice_end=$(echo "$episode_choice" | awk '{print $2}')
}

open_episode () {
	anime_id=$1
	episode=$2

	# clear the screen
	printf '\x1B[2J\x1B[1;1H'
	if [ $episode -lt 1 ] || [ $episode -gt $last_ep_number ]; then
		err "Episode out of range"
		printf "${c_blue}Choose episode ${c_cyan}[1-%d]$c_reset:$c_green " $last_ep_number
		read episode
		printf "$c_reset"
	fi

	printf "Getting data for \"%s\" episode %d/%d\n"  "$anime_id" "$episode" "$last_ep_number"

	video_url=$(get_links "$anime_id" "$episode")

	case $video_url in
		*streamtape*)
			# If direct download not available then scrape streamtape.com
			BROWSER=${BROWSER:-firefox}
			printf "scraping streamtape.com\n"
			video_url=$(curl -s "$video_url" | sed -n -E '
				/^<script>document/{
				s/^[^"]*"([^"]*)" \+ '\''([^'\'']*).*/https:\1\2\&dl=1/p
				q
				}
			');;
	esac

	if [ $is_download -eq 0 ]; then
		#setsid -f $player_fn "$video_url" >/dev/null 2>&1
		if [ "$dmenu" = "yes" ]; then
			$player_fn "$video_url" >/dev/null 2>&1
		else
			$player_fn "$video_url" >/dev/null 2>&1 &
			printf "\n${c_green}Currently playing %s episode ${c_cyan}%d/%d\n" "$anime_id" $episode $last_ep_number
		fi
	else
		printf "Downloading episode %s ...\n" "$episode"
		printf "%s\n" "$video_url"
		# add 0 padding to the episode name
		episode=$(printf "%03d" $episode)
		{
			curl -L -# -C - "$video_url" -o "${anime_id}-${episode}.mp4" &&
				printf "${c_green}Downloaded episode: %s${c_reset}\n" "$episode" ||
				printf "${c_red}Download failed episode: %s${c_reset}\n" "$episode"
		}
	fi
}

# Update the history when the user chooses
update_history () {
	sed -E "
		s/^${selection_id}\t[0-9]+/${selection_id}\t$((episode+1))/
	" "$logfile" > "${logfile}.new" && mv "${logfile}.new" "$logfile"
}

trackma_update () {
	anilist_name=$1
	current_episode=$2
	trackma -a "$trackma_account_no" update "$anilist_name" "$current_episode"
	trackma -a "$trackma_account_no" send
}

watching_animes_from_anilist () {
	trackma -a "$trackma_account_no" list | sed \
				-e "s/\x1b//g" \
				-e "s/^|[[:space:]]*[0-9]*[[:space:]]*//g" \
				-e "s:[|/0-9\? ]*$::g" \
				-e "s/\.*$//g" \
				-e "s/\[0m$//g" \
				-e "s/^[[;0-9]*m//g" \
				-e "/^[0-9]*[[:space:]]results$/d" \
				-e "/Index  Title/d"
}

settings () {
	printf "${c_blue}[${c_cyan}1${c_blue}]$c_yellow Delete anime from history.$c_reset\n"
	printf "${c_blue}[${c_cyan}2${c_blue}]$c_reset Sort anime in history.\n"
	printf "${c_blue}Enter choice:${c_green} "
	read -r settings_choice
	printf "$c_reset"
	case "$settings_choice" in
		1)
			if [ "$dmenu" = "yes" ]; then
				anime_to_delete=$(awk '{print $1}' "$logfile" | dmenu -i -l 30 -p "Select anime to remove: ")
			else
				anime_to_delete=$(awk '{print $1}' "$logfile" | fzf --layout=reverse --prompt "Select anime to remove: ")
			fi
			if [ -n "$anime_to_delete" ]; then
				sed -i "/$anime_to_delete/d" "$logfile"
				sed -i "/$anime_to_delete/d" "$trackmafile"
			else
				die "No anime selected."
			fi
			;;
		2)
			echo "Sorting logfile..."
			sort "$logfile" > "${logfile}.new" && mv "${logfile}.new" "$logfile"
			echo "Sorting trackmafile..."
			sort "$trackmafile" > "${trackmafile}.new" && mv "${trackmafile}.new" "$trackmafile"
			echo "Done."
			;;
	esac
}

############
# Start Up #
############

# to clear the colors when exited using SIGINT
trap "printf '$c_reset'" INT HUP

dep_ch "$player_fn" "curl" "sed" "grep" "awk" "fzf"
[ "$use_trackma" = "yes" ] && dep_ch "trackma"
[ "$dmenu" = "yes" ] && dep_ch "dmenu"

# option parsing
is_download=0
scrape=query
while getopts ':Dd:p:t:Hhs' OPT; do
	case $OPT in
		:)
			printf "$c_red%s.$c_reset\n" "Please provide an argument to -$OPTARG" >&2
			help_text | grep -e "USAGE" -e "\-$OPTARG"
			exit 1
			;;
		h)
			help_text
			exit 0
			;;
		D)
			is_download=1
			;;
		H)
			scrape=history
			;;
		s)
			settings
			exit 0
			;;
		d)
			case "$OPTARG" in
				1) dmenu="yes";;
				0) dmenu="no";;
				*) wrong_args "$OPT";;
			esac
			;;
		t)
			case "$OPTARG" in
				1) trackma="yes";;
				0) trackma="no";;
				*) wrong_args "$OPT";;
			esac
			;;
		p)
			[ "$OPTARG" != "$player_fn" ] && player_fn="$OPTARG" && printf "$c_green%s.$c_reset\n" "Changed player to $player_fn"
			;;
		?)
			echo "Invalid option: -${OPTARG}."
			help_text
			exit 1
			;;
	esac
done
shift $((OPTIND - 1))

########
# main #
########

# If vlc is used as a player, open vlc in fullscreen and close it after playing
[ "$player_fn" = "vlc" ] && player_fn="$player_fn --fullscreen --play-and-exit"

case $scrape in
	query)
		get_search_query "$*"
		search_results=$(search_anime "$query")
		[ -z "$search_results" ] && die "No search results found"
		if [ "$dmenu" = "yes" ]; then
			dmenu_anime_selection "$search_results"
			dmenu_episode_selection
		else
			anime_selection "$search_results"
			episode_selection
		fi
		;;
	history)
		search_results=$(sed -n -E 's/\t[0-9]*//p' "$logfile")
		[ -z "$search_results" ] && die "History is empty"
		if [ "$dmenu" = "yes" ]; then
			dmenu_anime_selection "$search_results"
		else
			anime_selection "$search_results"
		fi
		ep_choice_start=$(sed -n -E "s/${selection_id}\t//p" "$logfile")
		;;
esac


{ # checking input
	[ "$ep_choice_start" -eq "$ep_choice_start" ] 2>/dev/null || die "Invalid number entered"
	episodes=$ep_choice_start

	if [ -n "$ep_choice_end" ]; then
		[ "$ep_choice_end" -eq "$ep_choice_end" ] 2>/dev/null || die "Invalid number entered"
		# create list of episodes to download/watch
		episodes=$(seq $ep_choice_start $ep_choice_end)
	fi
}

# add anime to history file
grep -q -w "${selection_id}" "$logfile" ||
	printf "%s\t%d\n" "$selection_id" $((episode+1)) >> "$logfile"

# While updating Anilist using trackma, we need to use the name of the anime present in Anilist. Hence the need for trackmafile
if [ "$use_trackma" = "yes" ]; then
	trackma_id=$(grep "$selection_id" "$trackmafile" | awk -F\" '{print $2}')
	if [ -z "$trackma_id" ]; then
		if [ "$dmenu" = "yes" ]; then
			anime_name=$(watching_animes_from_anilist | dmenu -i -l 30 -p "Select an anime: (If anime not found, add it to anilist first)")
		else
			anime_name=$(watching_animes_from_anilist | fzf --layout=reverse --prompt "Select an anime: (If anime not found, add it to anilist first)")
		fi
		[ -z "$anime_name" ] && printf "${c_red}No anime selected.\n${c_reset}" && die "In case the anime you wanted was not available to choose, then you probably haven't added the anime to your anilist."
		printf "%s\t%s\n" "$selection_id" "\"$anime_name\"" >> "$trackmafile"
		trackma_id=$(grep "$selection_id" "$trackmafile" | awk -F\" '{print $2}')
	fi
fi

for ep in $episodes
do
	open_episode "$selection_id" "$ep"
done
episode=${ep_choice_end:-$ep_choice_start}

while :; do
	if [ "$dmenu" = "yes" ]; then
            choice=$(printf "n - update and watch next episode\nN - watch next episode\np - watch previous episode\ns - select episode\nq - update and exit\nQ - exit" | dmenu -l 6 | awk '{print $1}')
	else
		#printf "${c_green}Currently playing %s episode ${c_cyan}%d/%d\n" "$selection_id" "$episode" "$last_ep_number"
		printf "${c_blue}[${c_cyan}%s$c_blue] $c_yellow%s$c_reset\n" "n" "update and watch next episode"
		printf "${c_blue}[${c_cyan}%s$c_blue] $c_yellow%s$c_reset\n" "N" "watch next episode"
		printf "${c_blue}[${c_cyan}%s$c_blue] $c_magenta%s$c_reset\n" "p" "watch previous episode"
		printf "${c_blue}[${c_cyan}%s$c_blue] $c_yellow%s$c_reset\n" "s" "select episode"
		printf "${c_blue}[${c_cyan}%s$c_blue] $c_red%s$c_reset\n" "q" "update and exit"
		printf "${c_blue}[${c_cyan}%s$c_blue] $c_red%s$c_reset\n" "Q" "exit"
		printf "${c_blue}Enter choice:${c_green} "
		read -r choice
		printf "$c_reset"
	fi
	case $choice in
		n)
			[ "$use_trackma" = "yes" ] && trackma_update "$trackma_id" "$episode"
			update_history
			episode=$((episode + 1))
			;;

		N)
			episode=$((episode + 1))
			;;

		p)
			episode=$((episode - 1))
			;;

		s)
			if [ "$dmenu" = "yes" ]; then
				episode=$(echo "" | dmenu -p "Choose episode: ")
			else
				printf "${c_blue}Choose episode ${c_cyan}[1-%d]$c_reset:$c_green " $last_ep_number
				read episode
				printf "$c_reset"
			fi
			[ "$episode" -eq "$episode" ] 2>/dev/null || die "Invalid number entered"
			;;

		q)
			[ "$use_trackma" = "yes" ] && trackma_update "$trackma_id" "$episode"
			update_history
			break;;

		Q)
			break;;
		*)
			die "invalid choice"
			;;
	esac

	open_episode "$selection_id" "$episode"
done
