#!/bin/bash
. ./urls

CURRENT=""
VAULT=""
ANCIENT=""

# Get EOL versions:
# Create list of EOLed versions:
eol_vers=""

eol_list="$( perl getlinks.pl "${CURRENTURL}" | sed 's/\/$//gi' | grep "^[0-9]" )"

for major_ver in $( echo "${eol_list}" | tr " " "\n" | awk 'BEGIN { FS="."; } ; { print $1; }' | sort -u )
do
	found_readme=""
	found_readme="$( perl getlinks.pl "${CURRENTURL}/${major_ver}" |  grep -v "^\?" | grep -i "readme" )"
	if [[ ! -z "${found_readme}" ]]
	then
		eol_vers="$( echo "${eol_vers} ${major_ver}" | sed -e 's/^ *//g' -e 's/ *$//g' )"
	fi
done
eol_vers_grep="$( echo "${eol_vers}" | tr " " "\n" | sed 's/^/\^/g' | tr "\n" " " | sed -e 's/^ *//g' -e 's/  *$//g' -e 's/ /\\|/g' )"

#echo "Centos EOL Vers: ${eol_vers}"
#echo "Centos EOL Vers Grep: ${eol_vers_grep}"

for ageclass in ANCIENTURL VAULTURL CURRENTURL
do
	case "${ageclass}" in
		ANCIENTURL) url=${ANCIENTURL} ;;
		VAULTURL) url=${VAULTURL} ;;
		CURRENTURL) url=${CURRENTURL} ;;
	esac

	
	list="$( perl getlinks.pl "$url" | sed 's/\/$//gi' | grep "^[0-9]" )"
	list=$( echo "${list}" | grep -vi "Name\|Last modified\|Size\|Parent Directory\|beta" )
	#list=$( echo "${list}" | grep -vi "kernel\|index\|build\|dostools\|graphics\|debuginfo\|\?\|newbb\|readme\|HEADER\|RPM-GPG-KEY-beta\|TIME\|timestamp.txt\|beta" )

	case "${ageclass}" in
		ANCIENTURL)
			ANCIENT="$( echo "$list" | grep "^2" | tr "\n" " " )"
			;;
		VAULTURL)
			# create "latest" versions to ignore in vault
			# 2 should always be ignored, it's ancient

			# Now figure out what's left

			last_vers=""
			major_vers="$( echo "${list}" | tr " " "\n" | awk 'BEGIN { FS="."; } ; { print $1; }' | sort -u | grep -v "${eol_vers_grep}" | tr "\n" " ")"
			#echo "Major Vers: ${major_vers}"
			for major_ver in ${major_vers}
			do
				last_vers="$( echo "${last_vers} $( echo "${list}" | grep "^${major_ver}" | tail -n 1 )" | tr " " "\n" | sort -u | tr "\n" " " | sed -e 's/^ *//g' -e 's/ *$//g' )"
			done
			#echo "Last Vers: ${last_vers}"
			last_vers_grep="$( echo "${last_vers}" | sed -e 's/ /\\|/g' )"
			#echo "Last Vers Grep: ${last_vers_grep}"
			VAULT="$( echo "$list" | grep -v "^2" | grep -v "${last_vers_grep}" |  tr "\n" " " )"
			;;
		CURRENTURL)
			cur_grep="$( echo "${eol_vers_grep}\|$( echo "${VAULT}" | sed -e 's/\s/\\|/gi' -e 's/\\|$//' -e 's/^\\|//g' )" | sed -e 's/\\|$//' -e 's/^\\|//g' )"
			CURRENT="$( echo "$list" | grep -v "${cur_grep}" | sed -e 's/\s/\\|/gi' -e 's/\\|$//' -e 's/^\\|//g' | tr "\n" " " )"
			;;
	esac
done

echo "EOL = ${eol_vers}"
echo "ANCIENT = ${ANCIENT}"
echo "VAULT = ${VAULT}"
echo "CURRENT = ${CURRENT}"
