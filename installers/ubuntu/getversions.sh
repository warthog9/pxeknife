#!/bin/bash
. ./urls

CURRENT=""
ARCHIVE=""

for ageclass in ARCHIVEURL CURRENTURL
do
	eval url=\$$ageclass
	
	list="$( perl getlinks.pl "$url" | sed 's/\/$//gi' )"
	list=$( echo "${list}" | grep -vi "kernel\|index\|build\|dostools\|graphics\|debuginfo\|\?\|newbb\|readme\|HEADER\|RPM-GPG-KEY-beta\|TIME\|timestamp.txt\|beta\|test\|linux\|updates\|development\|releases\|backports\|proposed\|security\|/ubuntu" )

	case "${ageclass}" in
		ARCHIVEURL)
			#ARCHIVE="$( echo "$list" | grep -i "debian[0-9]\|debian-\|stable\|unstable\|testing\|oldstable\|experimental" | tr "\n" " " )"
			ARCHIVE="$( echo "$list" | grep -vi "m68k\|proposed\|updates\|buggy\|/debian" | tr "\n" " " )"
			;;
		CURRENTURL)
			#CURRENT="$( echo "$list" | grep -i "debian[0-9]\|debian-\|stable\|unstable\|testing\|oldstable\|experimental" | tr "\n" " " )"
			CURRENT="$( echo "$list" | grep -vi "m68k\|proposed\|updates\|buggy\|/debian" | grep -v "$( echo "${ARCHIVE}" | sed -e 's/^ *//g' -e 's/ *$//g' -e 's/ /\\|/g' )" | tr "\n" " " )"
			;;
	esac
done

for x in ARCHIVE CURRENT
do
	eval versionlist=\$$x
	echo "${x} = ${versionlist}"
done

for x in ARCHIVE CURRENT
do
	eval versionlist=\$$x
	ALLVERS="$( echo "${ALLVERS} ${versionlist}" | tr " " "\n" | sort -u | tr "\n" " " | sed -e 's/^ *//g' -e 's/ *$//g' )"

done

echo "ALLVERS = ${ALLVERS}"

