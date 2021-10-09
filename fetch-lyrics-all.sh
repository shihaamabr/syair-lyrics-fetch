#!/bin/bash

NOOFFILES=$(ls /sdcard/* | grep '.mp3\|.m4a' |wc -l)
cyan=`tput setaf 39`
yellow=`tput setaf 11`
reset=`tput sgr0`

i=0;
for song in `ls /sdcard/* | grep '.mp3\|.m4a'`
do
	songname[$i]=$song;
	i=$(($i+1));
		if [ "$i" = "$NOOFFILES" ]
		then
			exit
		fi
	SELECT=$(ls /sdcard/* | grep '.mp3\|.m4a' | head -n$i | tail -n1)
	QUERY=$(echo $SELECT | sed 's/ /%20/g')
	SEARCH=$(curl -s https://www.syair.info/search?q=${QUERY} | pup 'a.title json{}')
	HREF=$(echo $SEARCH | jq '.[].href' | head -n1 | sed 's/"//g')
	TEXT=$(echo $SEARCH | jq '.[].text' | head -n1 | sed 's/"//g' | sed "s/\&#39\;/'/g")
	SONGNAME=$(echo $TEXT | cut --complement -d '-' -f 1 | cut -f1 -d '.' | sed 's/ //')
	ARTISTNAME=$(echo $TEXT| cut -f1 -d '-' | head -c -2)
	FETCH=$(curl -s https://www.syair.info/${HREF} | tail -n +13 | sed "s/<br>//g" | cut --complement -d '>' -f 1 | sed 's/\&quot\;/"/g' \
		| head -n -1 > "/sdcard/RetroMusic/lyrics/${SONGNAME} - ${ARTISTNAME}.lrc")

	echo ${cyan}Lyrics for file ${yellow}$SELECT${cyan} saved as ${yellow}${SONGNAME} - ${ARTISTNAME}.lrc

done
