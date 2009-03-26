#!/bin/bash
. ./urls

CURRENT=""
VAULT=""
ANCIENT=""

for ageclass in ARCHIVEURL ARCHIVECOREURL CURRENTURL CURRENTTESTURL DEVELOPMENTURL
do
	eval url=\$$ageclass
	
	
	list="$( perl getlinks.pl "$url" | sed 's/\/$//gi' | grep "^[0-9]" )"
	list=$( echo "${list}" | grep -vi "Name\|Last modified\|Size\|Parent Directory" )
	#list=$( echo "${list}" | grep -vi "kernel\|fedora\|index\|build\|dostools\|graphics\|debuginfo\|\?\|newbb\|readme\|HEADER\|RPM-GPG-KEY-beta\|TIME\|timestamp.txt\|beta\|test\|linux\|updates\|development\|releases" )

	case "${ageclass}" in
		ARCHIVEURL)
			ARCHIVE="$( echo "$list" | tr "\n" " " )"
			;;
		ARCHIVECOREURL)
			ARCHIVECORE="$( echo "$list" | tr "\n" " " )"
			;;
		CURRENTURL)
			CURRENT="$( echo "$list" | grep -v "^$(echo "${ARCHIVECORE} ${ARCHIVE}" | sed -e 's/\s/\$\\|/gi' | sed -e 's/^\\|//' -e 's/\\|$//' -e 's/|\\//gi' | sed -e 's/|/|\^/gi')" | tr "\n" " " )"
			;;
		CURRENTTESTURL)
			CURRENTTEST="$( echo "$list" | tr "\n" " " )"
			;;
		DEVELOPMENTURL)
			DEVELOPMENT="$( echo "$list" | tr "\n" " " )"
			;;
	esac
done

for x in ARCHIVECORE ARCHIVE CURRENT CURRENTTEST DEVELOPMENT
do
	eval versionlist=\$$x
	echo "${x} = ${versionlist}"
done

#ALLVERS = $(ARCHIVE) $(ARCHIVECORE) $(CURRENT) $(CURRENTTEST) $(DEVELOPMENT)
#ALLVERS_32bit = $(ARCHIVE) $(ARCHIVECORE) $(CURRENT) $(CURRENTTEST) $(DEVELOPMENT)
#ALLVERS_64bit = $(shell echo $(ARCHIVECORE) | tr "1" " ") $(ARCHIVE) $(CURRENT) $(CURRENTTEST) $(DEVELOPMENT)


for x in ARCHIVECORE ARCHIVE CURRENT CURRENTTEST
do
	eval versionlist=\$$x
	ALLVERS="${ALLVERS} ${versionlist}"

done

echo "ALLVERS = ${ALLVERS}"
echo "ALLVERS_32bit = ${ALLVERS}"
echo "ALLVERS_64bit = $(echo "${ALLVERS}" | sed 's/\s1\s/ /' )"

