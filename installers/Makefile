SHELL = /bin/bash

#.SILENT:

#.PHONY: centos centos_clean

ifdef CONFIG
include $(CONFIG)
NEWCONFIG="../$(CONFIG)"
else
NEWCONFIG=""
endif

ifdef CENTOS
DIRS := $(DIRS) centos
endif

ifdef FEDORA
DIRS := $(DIRS) fedora
endif

ifdef DEBIAN
DIRS := $(DIRS) debian
endif

all: make_statement configfile $(DIRS)

make_statement:
	echo "--> Generating Installers"

$(DIRS): make_statement
	$(MAKE) $(MFLAGS) ABSPATH="$(ABSPATH)/$@" CONFIG="$(NEWCONFIG)" -C $@ -f Makefile


