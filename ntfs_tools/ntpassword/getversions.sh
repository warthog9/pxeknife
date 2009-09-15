#!/bin/bash
. ./urls

list="$( perl getlinks.pl "${NTPASSWORDURL}" | grep -i "^[cb]d.*zip$" )"

NTPASSWORDCD="$( echo "$list" | grep "^cd" | tr "\n" " " )"
NTPASSWORDFD="$( echo "$list" | grep "^bd" | tr "\n" " " )"
NTPASSWORDLATEST="$( echo "$list" | grep "^bd" | sort | tail -n 1 )"
NTPASSWORDLATEST="${NTPASSWORDLATEST} $( echo "$list" | grep "^cd" | sort | tail -n 1 )"
				
echo "NTPASSWORDCD = ${NTPASSWORDCD}"
echo "NTPASSWORDFD = ${NTPASSWORDFD}"
echo "ALLVERS = ${NTPASSWORDCD} ${NTPASSWORDFD}"
echo "LATEST = ${NTPASSWORDLATEST}"
