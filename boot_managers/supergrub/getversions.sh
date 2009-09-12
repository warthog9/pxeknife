#!/bin/bash
. ./urls

SGD1=""
SGD2=""

list="$( perl getlinks.pl "${SUPERGRUBDISKURL}" | grep "floppy" )"

for ageclass in SGD1 SGD2
do
	case "${ageclass}" in
		SGD1)
			SGD1_VER="$( echo "$list" | grep "^super_grub_disk" | grep "english" | sort -n | tail -n 1 | awk 'BEGIN { FS="_"; } ; { print $NF; };' | sed 's/.img//' )"
			SGD1="$( echo "$list" | grep "^super_grub_disk" | grep "${SGD1_VER}" | tr "\n" " " )"
				
			;;
		SGD2)
			SGD2_VER="$( echo "$list" | grep "^sgd_floppy" | sort -n | tail -n 1 | awk 'BEGIN { FS="_"; } ; { print $NF; };' | sed 's/.img.gz//' )"
			SGD2="$( echo "$list" | grep "^sgd_floppy" | grep "${SGD2_VER}" | tr "\n" " ")"
			;;
	esac
done

echo "SGD1 = ${SGD1}"
echo "SGD1_VER = ${SGD1_VER}"
echo "SGD2 = ${SGD2}"
echo "SGD2_VER = ${SGD2_VER}"
echo "ALLVERS = ${SGD1} ${SGD2}"
