#!/bin/bash
. ./urls

TOMSRTBT=""

list="$( perl getlinks.pl "${TOMSRTBTURL}" | grep tomsrtbt | grep "extract" )"

TOMSRTBT_VER="$( echo "$list" | sort | tail -n 1 | awk 'BEGIN { FS="-"; } ; { print $2; }' | sed s'/\.extract\.tar\.bz2//' )"
TOMSRTBT="$( echo "$list" | sort | tail -n 1 )"
				
echo "TOMSRTBT = ${TOMSRTBT}"
echo "TOMSRTBT_VER = ${TOMSRTBT_VER}"
echo "ALLVERS = ${TOMSRTBT}"
echo "LATEST = ${TOMSRTBT}"
