#!/bin/bash
. ./urls

CURRENT=""
ARCHIVE=""

for ageclass in ARCHIVEURL CURRENTURL
do
	case "${ageclass}" in
		ARCHIVEURL) url=${ARCHIVEURL} ;;
		CURRENTURL) url=${CURRENTURL} ;;
	esac

	list="$( perl getlinks.pl "$url" | sed 's/\/$//gi' | grep "ftp.*\.iso$\|latest\|^[0-9]" )"

	case "${ageclass}" in
		ARCHIVEURL)
			ARCHIVE="$( echo "$list" | sed 's/^arch-\(.*\)-ftp-\(i686\|x86_64\).iso$/\1/' | sort -u | tr "\n" " " )"
			;;
		CURRENTURL)
			CURRENT="$( echo "$list" | grep -v "$(echo "${ARCHIVE}" | sed 's/\s/\\|/gi' | sed 's/\\|$//' )" | tr "\n" " " )"
			;;
	esac
done

echo "ARCHIVE = ${ARCHIVE}"
echo "CURRENT = ${CURRENT}"
