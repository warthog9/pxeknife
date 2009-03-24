#!/bin/bash

function print_usage {
	echo "PXE Knife - Script to acquire the latest Syslinux"
	echo
	echo "Usage: $( basename "${_progname}" ) [-h|--help] [-t<path>|--tempdir=<path>] [-b<path>|--basedir=<path>]"
	echo
	echo "  -b   --basedir   Path to the base directory to save syslinux to      [REQUIRED]"
	echo "  -t   --tempdir   Path to the temporary directory to save syslinux to [REQUIRED]"
	echo "  -h   --help      Displays this help messagei                         [Optional]"
}

_wgetopts="-N -c"

_cmdline="$@"

_progname="${0}"

_options=$(getopt -o ht:b: -l help,tempdir:,basedir: -- "$@")

TEMPDIR=""
BASEDIR=""

if [[ $? != 0 ]];
then
    echo "Terminating"
    exit 1
fi

eval set -- "${_options}"
while true;
do
	case "${1}" in
	--)
		# Reached the end, bail out
		shift
		break
		;;
	-t | --tempdir )
		if [[ ${2} == "" ]];
		then
			echo "*** Missing Temporary Directory (-t | --tempdir)"
			exit 1
		fi
		TEMPDIR="${2}"
		shift 2
		;;
	-b | --basedir )
		if [[ ${2} == "" ]];
		then
			echo "*** Missing Base Directory (-b | --basedir)"
			exit 1
		fi
		BASEDIR="${2}"
		shift 2
		;;
	-h | --help )
		print_usage
		exit 1
		;;
	*)
		echo "Unknown option ${1}."
		shift
	esac
done

if [[ "${TEMPDIR}" = "" ]]
then
	print_usage
	echo
	echo "***"
	echo "*** Missing Temporary Directory (-t | --tempdir)"
	echo "***"
	exit
fi

if [[ "${BASEDIR}" = "" ]]
then
	print_usage
	echo
	echo "***"
	echo "*** Base Directory (-b | --basedir)"
	echo "***"
	exit
fi

syslinuxpage="$( curl http://www.kernel.org/pub/linux/utils/boot/syslinux/ )"
syslinuxlist="$(
		echo "${syslinuxpage}" \
			| grep syslinux \
			| grep bz2 \
			| sed 's/>/ /gi' \
			| awk '{print $$2;}' \
			| sed \
				-e 's/href=//' \
				-e 's/"//gi' \
				-e 's/<a//gi' \
				-e 's/<\/a//gi' \
			| grep -v sign
			
		)"

syslinuxlatest="$(
		echo "${syslinuxlist}" \
			| sort \
			| tail -n 1 \
			| awk '{ print $1; }'

		)"
echo "***"
echo "*** ${syslinuxlatest}"
echo "***"

wget \
	${_wgetopts} \
	-P ${TEMPDIR} \
	"http://www.kernel.org/pub/linux/utils/boot/syslinux/${syslinuxlatest}"

(
	cd "${TEMPDIR}"
	tar -xjvf "${syslinuxlatest}"
	tempIFS="${IFS}"
	IFS="
	"
	for x in $( \
			find "$( echo "${syslinuxlatest}" | sed 's/.tar.bz2//' )/" \
				-type f \
				-name "*.c32" \
				-o \
				-type f \
				-name "memdisk" \
				-o \
				-type f \
				-name pxelinux.0 \
			| grep -v sample \
		)
	do
		mkdir -v -p "${BASEDIR}/syslinuxdir"
		mv -v "${x}" "${BASEDIR}/syslinuxdir"
	done
	IFS="${tempIFS}"
)

