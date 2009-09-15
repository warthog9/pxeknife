#!/bin/bash
. ./urls

list="$( perl getlinks.pl "${RIPURL}" | grep -i PXE | grep -i zip | grep -v "non" )"

RIP_VER="$( echo "$list" | sed -e 's/RIPLinuX-//' -e 's/.PXE.zip//' )"
RIP="$( echo "$list" | sort | tail -n 1 )"
				
echo "RIP = ${RIP}"
echo "RIP_VER = ${RIP_VER}"
echo "ALLVERS = ${RIP}"
echo "LATEST = ${RIP}"
