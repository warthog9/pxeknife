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

ifdef UBUNTU
DIRS := $(DIRS) ubuntu
endif

ifdef REDHAT
DIRS := $(DIRS) redhat
endif

#configfile = label @LABEL@\n \
#	     \tMENU LABEL @DISTRO@ \n \
#	     \tKERNEL menu.c32 \n \
#	     \tAPPEND @CONFIGFILE@\n
configfile = MENU INCLUDE @CONFIGFILE@ @DISTRO@\n

all: make_statement configfile $(DIRS)

make_statement:
	echo "--> Generating Installers"

configfile: $(DIRS) installers.conf
installers.conf: $(subst %,%/%.conf,$(DIRS))
	cat /dev/null > $@; \
	_SUBDIR="$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)" | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )"; \
	_BASEDIR="$(PXEKNIFEPREFIX)/"; \
	echo "MENU INCLUDE $${_BASEDIR}/pxeknife-gui.conf" >> $@; \
	echo "MENU TITLE OS Installers" >> $@; \
	echo "label UpDir" >> $@; \
	echo "	MENU EXIT" >> $@; \
	echo "label blankspace" >> $@; \
	echo "	MENU LABEL " >> $@; \
        for x in $(DIRS); \
        do \
		if [[ -e "$${x}/$${x}.conf" ]]; \
		then \
			echo "~~ $${x}"; \
			printf "$(configfile)" | \
		        sed \
		                -e "s/@DISTRO@/$${x}/" \
		                -e "s/@CONFIGFILE@/$${_SUBDIR}\/$${x}\/$${x}.conf/" \
		                -e "s/@LABEL@/$${x}/" >> $@; \
		fi \
        done

$(DIRS): make_statement
	$(MAKE) $(MFLAGS) ABSPATH="$(ABSPATH)/$@" CONFIG="$(NEWCONFIG)" -C $@ -f Makefile

clean: make_statement $(patsubst %,%.clean,$(DIRS))
	-rm -rf *.conf

$(patsubst %,%.clean,$(DIRS)):
	$(MAKE) $(MFLAGS) ABSPATH="$(ABSPATH)/$@" CONFIG="$(NEWCONFIG)" -C $(patsubst %.clean,%,$@) -f Makefile clean

