SHELL = /bin/bash

TEMPDIR = pxektemp

PWD := $(shell pwd)


ifndef CONFIG
CONFIG=CONFIG
endif

-include $(CONFIG)

ABSPATH = 

export PXEKNIFEPREFIX

.SILENT:

#DIRS = boot_managers hard_drive_utils knoppix linux_boot_disks memory_test ntfs_tools random_utils system_information installers
DIRS = installers

configfile = label @LABEL@\n \
	     \tMENU LABEL @DISTRO@ \n \
	     \tKERNEL menu.c32 \n \
	     \tAPPEND @CONFIGFILE@\n


all: make_statement $(DIRS)

clean: make_statement $(patsubst %,%.clean,$(DIRS))

make_statement:
	echo "Hello World!"

$(DIRS): make_statement
	$(MAKE) $(MFLAGS) ABSPATH="$(ABSPATH)/$@" CONFIG="../$(CONFIG)" -C $@ -f Makefile

$(patsubst %,%.clean,$(DIRS)):
	$(MAKE) $(MFLAGS) ABSPATH="$(ABSPATH)/$@" CONFIG="../$(CONFIG)" -C $(patsubst %.clean,%,$@) -f Makefile clean

#boot_managers: make_statement
#	$(MAKE) $(MFLAGS) CONFIG="../CONFIG" -C boot_managers -f Makefile
#
#hard_drive_utils: make_statement
#	$(MAKE) $(MFLAGS) CONFIG="../CONFIG" -C hard_drive_utils -f Makefile
#
#knoppix:
#
#linux_boot_disks: make_statement
#	$(MAKE) $(MFLAGS) CONFIG="../CONFIG" -C linux_boot_disks -f Makefile
#
#memory_test: make_statement
#	$(MAKE) $(MFLAGS) CONFIG="../CONFIG" -C memory_test -f Makefile
#
#ntfs_tools: make_statement
#	$(MAKE) $(MFLAGS) CONFIG="../CONFIG" -C ntfs_tools -f Makefile
#
#random_utils: make_statement
#	$(MAKE) $(MFLAGS) CONFIG="../CONFIG" -C random_utils -f Makefile
#
#system_information: make_statement
#	$(MAKE) $(MFLAGS) CONFIG="../CONFIG" -C system_information -f Makefile
#
#installers: make_statement
#	$(MAKE) $(MFLAGS) CONFIG="../CONFIG" -C installers -f Makefile

tempdir: make_statement
	mkdir -p $(TEMPDIR)

getsyslinux: make_statement tempdir
	.pxeknife_utils/getsyslinux.sh --tempdir="$(TEMPDIR)" --basedir="$(PWD)"


configfile: $(DIRS) pxeknife.conf
pxeknife.conf: $(subst %,%/%.conf,$(DIRS))
	cat /dev/null > $@; \
        for x in $(DIRS); \
        do \
		if [[ -e "$${x}/$${x}.conf" ]]; \
		then \
			echo "~~ $${x}"; \
			printf "$(configfile)" | \
		        sed \
		                -e "s/@DISTRO@/$${x}/" \
		                -e "s/@CONFIGFILE@/$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)" | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )\/$${x}\/$${x}.conf/" \
		                -e "s/@LABEL@/$${x}/" >> $@; \
		fi \
        done

