#!/bin/bash
# shellcheck disable=SC2001
SQL="SELECT b.title || \" | \" ||  p.url  FROM moz_bookmarks b JOIN moz_places p ON b.fk = p.id WHERE b.fk is not null AND b.title <> '' AND url <> '' AND url NOT LIKE 'place:%'"

FIREFOX_PROFILE="mdup32fn.default-release"

PROFILE_DB="$HOME/.mozilla/firefox/$FIREFOX_PROFILE/places.sqlite"
TMP_PLACES="/tmp/places"

# Avoid db lock
cp -f "$PROFILE_DB" "$TMP_PLACES"
ENTRIES=$(sqlite3 "$TMP_PLACES" "$SQL" | rofi -i -dmenu -p "Firefox")

read -ra ADDR <<<"$ENTRIES"
for i in "${ADDR[@]}"; do
	URL="$i"
done

if [ ! "${ADDR[0]}" ]; then
	rm "$TMP_PLACES"
	exit 0
fi

UURL() {
	if [ "$2" ]; then
		URL="$1$2"
	else
		exclusive=$(printf '%s\n' "$ENTRIES" | sed 's/[^ ]* //')
		URL="$1$exclusive"
	fi
}

SITE() {
	exclusive=$(printf '%s\n' "$ENTRIES" | sed 's/[^ ]* //')
	notify-send 'Firefox' "Searching in $1: $exclusive"
}

case "${ADDR[0]}" in
"youtube" | "yt")
	SITE "YouTube"
	UURL "https://www.youtube.com/results?search_query="
	;;
"piped" | "yt2")
	SITER "Piped"
	UURL "https://piped.kavin.rocks/results?search_query="
	;;
"crate")
	SITE "Crates.io"
	UURL "https://crates.io/search?q="
	;;
"docs.rs" | "rustdoc" | "docsrs" | "rdocs" | "docs" | "doc")
	SITE "Docs.rs"
	UURL "https://docs.rs/releases/search?query="
	;;
"stddoc" | "rustdocstd" | "rsdoc")
	SITE "Rust STD Nightly Docs"
	UURL "https://doc.rust-lang.org/nightly/std/?search="
	;;
"rexplain" | "rerror")
	SITE "Rust Compiler Error Index"
	UURL "https://doc.rust-lang.org/error-index.html#"
	;;
*)
	if [[ ! "$URL" = http* ]]; then
		notify-send 'Firefox' "Searching in SearX: $ENTRIES"
		UURL "https://searx.info/search?q=" "$ENTRIES"
	else
		notify-send 'Firefox' "Opening: $URL"
	fi
	;;
esac

firefox "$URL"

rm -f "$TMP_PLACES"
