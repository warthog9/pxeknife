SHELL = /bin/bash

TEMPDIR = pxektemp

PWD := $(shell pwd)

ABSPATH = 

.SILENT:

all: make_statement

clean: make_statement

make_statement:
	echo "Hello World!"

tempdir: make_statement
	mkdir -p $(TEMPDIR)

getsyslinux: make_statement tempdir
	.pxeknife_utils/getsyslinux.sh --tempdir="$(TEMPDIR)" --basedir="$(PWD)"

