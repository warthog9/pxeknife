SHELL = /bin/bash

.SILENT:

.PHONY: centos

all: make_statement centos

make_statement:
	echo "--> Generating Installers"

centos: make_statement
	$(MAKE) $(MFLAGS) CONFIG="$(NEWCONFIG)" -C centos -f Makefile

