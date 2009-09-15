#!/bin/bash
. ./urls

list="$( perl getlinks.pl "${PCISNIFFERURL}" | grep zip | sort -u )"

PCISNIFFER="$( for x in $list;do basename "${x}";done | tr "\n" " " )"
PCISNIFFERLATEST="$( for x in $list;do basename "${x}";done | sort | tail -n 1 )"
PCISNIFFER_VER="$( for x in $list;do basename "${x}" | sed -e 's/^pcisniffer\.//' -e 's/\.en\.zip//';done | sort -u | tail -n 1)"
				
echo "PCISNIFFER = ${PCISNIFFER}"
echo "PCISNIFFER_VER = ${PCISNIFFER_VER}"
echo "ALLVERS = ${PCISNIFFER}"
echo "LATEST = ${PCISNIFFER}"
