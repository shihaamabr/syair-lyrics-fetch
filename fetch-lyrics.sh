#!/bin/bash

QUERY=$(echo $1 | sed "s/ /+/g")

SEARCH=$(curl -s https://www.syair.info/search?q=${QUERY} \
	| pup 'a.title json{}')

HREF=$(echo $SEARCH \
	| jq '.[].href' \
	| head -n1 \
	| sed 's/"//g')
TEXT=$(echo $SEARCH \
	| jq '.[].text' \
	| head -n1 \
	| sed 's/"//g')

SONGNAME=$(echo $TEXT | cut --complement -d '-' -f 1 | cut -f1 -d '.' | sed 's/ //')
ARTISTNAME=$(echo $TEXT| cut -f1 -d '-' | head -c -2)

FETCH=$(curl -s https://www.syair.info/${HREF} \
	| tail -n +13 \
	| sed "s/<br>//g" \
	| cut --complement -d '>' -f 1 \
	| sed 's/\&quot\;/"/g' \
	| head -n -1 > "/sdcard/RetroMusic/lyrics/${SONGNAME} - ${ARTISTNAME}.lrc")
