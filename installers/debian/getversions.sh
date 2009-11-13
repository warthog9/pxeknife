#!/bin/bash
. ./urls

CURRENT=""
ARCHIVE=""

for ageclass in ARCHIVEURL CURRENTURL
do
	eval url=\$$ageclass
	
	list="$( perl getlinks.pl "$url" | sed 's/\/$//gi' )"
	list=$( echo "${list}" | grep -vi "kernel\|index\|build\|dostools\|graphics\|debuginfo\|\?\|newbb\|readme\|HEADER\|RPM-GPG-KEY-beta\|TIME\|timestamp.txt\|beta\|test\|linux\|updates\|development\|releases\|debian-archive\|experimental" )
	# This is done because the following releases don't contain the right information for network instalation that I know of:
	list=$( echo "${list}" | grep -vi "0.93R6\|Debian-1.1\|buzz\|Debian-1.2\|rex\|Debian-1.3.1\|bo\|Debian-2.0\|hamm\|Debian-2.1\|slink\|Debian-2.2\|potato\|Debian-3.0\|woody" )

	case "${ageclass}" in
		ARCHIVEURL)
			#ARCHIVE="$( echo "$list" | grep -i "debian[0-9]\|debian-\|stable\|unstable\|testing\|oldstable\|experimental" | tr "\n" " " )"
			ARCHIVE="$( echo "$list" | grep -vi "m68k\|proposed\|updates\|buggy\|/debian" | tr "\n" " " )"
			;;
		CURRENTURL)
			#CURRENT="$( echo "$list" | grep -i "debian[0-9]\|debian-\|stable\|unstable\|testing\|oldstable\|experimental" | tr "\n" " " )"
			CURRENT="$( echo "$list" | grep -vi "m68k\|proposed\|updates\|buggy\|/debian" | tr "\n" " " )"
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
	ALLVERS="${ALLVERS} ${versionlist}"

done

echo "ALLVERS = ${ALLVERS}"
echo "ALLVERS_32bit = ${ALLVERS}"
echo "ALLVERS_64bit = $(echo "${ALLVERS}" | sed -e 's/\s1\s/ /' -e 's/Debian-3.1//g' -e 's/sarge//g' )"

