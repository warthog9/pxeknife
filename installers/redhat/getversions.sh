#!/bin/bash
. ./urls

CURRENT=""
VAULT=""
ANCIENT=""

for ageclass in ANCIENTURL VAULTURL CURRENTURL
do
	case "${ageclass}" in
		ANCIENTURL) url=${ANCIENTURL} ;;
		VAULTURL) url=${VAULTURL} ;;
		CURRENTURL) url=${CURRENTURL} ;;
	esac
	
	list="$( perl getlinks.pl "$url" | sed 's/\/$//gi' | grep "^[0-9]" )"
	list=$( echo "${list}" | grep -vi "Name\|Last modified\|Size\|Parent Directory\|beta" )
	#The following are excluded due to not having network bootability:
	list=$( echo "${list}" | grep -vi "^1\|^2\|^3\|^4\|^5" )
	#The following are excluded due to unusable architectures
	list=$( echo "${list}" | grep -vi "iSeries\|pSeries\|s390x" )
	#list=$( echo "${list}" | grep -vi "kernel\|index\|build\|dostools\|graphics\|debuginfo\|\?\|newbb\|readme\|HEADER\|RPM-GPG-KEY-beta\|TIME\|timestamp.txt\|beta" )

	case "${ageclass}" in
		ANCIENTURL)
			ANCIENT="$( echo "$list" | grep -v "^[7-9]" | tr "\n" " " )"
			;;
		VAULTURL)
			VAULT="$( echo "$list" | grep -v "^6" |  tr "\n" " " )"
			;;
		CURRENTURL)
			CURRENT="$( echo "$list" | grep -v "$(echo "${VAULT}" | sed 's/\s/\\|/gi' | sed 's/\\|$//' )" | tr "\n" " " )"
			;;
	esac
done

echo "ANCIENT = ${ANCIENT}"
echo "VAULT = ${VAULT}"
echo "CURRENT = ${CURRENT}"
