SHELL = /bin/bash

TEMPDIR = pxektemp

PWD := $(shell pwd)

ABSPATH = 

.SILENT:

all: make_statement boot_managers hard_drive_utils knoppix linux_boot_disks memory_test ntfs_tools random_utils system_information installers

clean: make_statement

make_statement:
	echo "Hello World!"

boot_managers: make_statement
	$(MAKE) $(MFLAGS) CONFIG="../CONFIG" -C boot_managers -f Makefile

hard_drive_utils: make_statement
	$(MAKE) $(MFLAGS) CONFIG="../CONFIG" -C hard_drive_utils -f Makefile

knoppix:
	$(MAKE) $(MFLAGS) CONFIG="../CONFIG" -C knoppix -f Makefile

linux_boot_disks: make_statement
	$(MAKE) $(MFLAGS) CONFIG="../CONFIG" -C linux_boot_disks -f Makefile

memory_test: make_statement
	$(MAKE) $(MFLAGS) CONFIG="../CONFIG" -C memory_test -f Makefile

ntfs_tools: make_statement
	$(MAKE) $(MFLAGS) CONFIG="../CONFIG" -C ntfs_tools -f Makefile

random_utils: make_statement
	$(MAKE) $(MFLAGS) CONFIG="../CONFIG" -C random_utils -f Makefile

system_information: make_statement
	$(MAKE) $(MFLAGS) CONFIG="../CONFIG" -C system_information -f Makefile

installers: make_statement
	$(MAKE) $(MFLAGS) CONFIG="../CONFIG" -C installers -f Makefile

tempdir: make_statement
	mkdir -p $(TEMPDIR)

getsyslinux: make_statement tempdir
	.pxeknife_utils/getsyslinux.sh --tempdir="$(TEMPDIR)" --basedir="$(PWD)"

