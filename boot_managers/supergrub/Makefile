SHELL = /bin/bash

include urls
-include versions.list

ifdef CONFIG
-include $(CONFIG)
endif

WGETOPTS = -q -nc -c
#WGETOPTS = -c


configfile = label @LABEL@\n \
	     \tMENU LABEL @SGDVERSTRING@ @VERSION@\n \
	     \tKERNEL memdisk \n \
	     \tAPPEND initrd=@PATH@/@FILE@ \n \

export ABSPATH

#.SILENT:

.PHONY:

ifdef SUPERGRUBDISK
buildtarget: $(SUPERGRUBDISK)
else
buildtarget: $(ALLVERS)
endif

all: $(ALLVERS) make_statement
latest: $(ALLVERS) make_statement

$(ALLVERS): make_statement
	printf "\055-----> Getting Super Grub Disk %-3s\n" "$@"
	wget $(WGETOPTS) $(SUPERGRUBDISKURL)/$@
	if [[ "$(shell echo "$@" | awk 'BEGIN { FS="."; } ; { print $$NF;}')" = "gz" ]]; \
	then gunzip -f $@;fi
	-rm -rf supergrub.conf
	$(MAKE) $(MFLAGS) -f $(MAKEFILE_LIST) configfile

versions.list:
	./getversions.sh > $@

clean: cleanconfig
	-rm -rf super_grub_disk* sgd_floppy_* versions.list

cleanconfig:
	-rm -rf supergrub.conf

make_statement:
	echo "----> Aquiring and Setting up Super Grub Disk"

configfile: supergrub.conf
supergrub.conf:
	cat /dev/null > $@
	for x in $$( ls sgd_floppy* | sort ); \
	do \
		_VER="$$(echo "$${x}" | awk 'BEGIN { FS="_"; } ; { print $$NF; }' | sed 's/.img//' )"; \
		_FILE="$${x}"; \
		printf "$(configfile)" | \
		sed \
			-e "s/@SGDVERSTRING@/Super Grup Disk v2 - /" \
			-e "s/@PATH@/$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)" | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )/" \
			-e "s/@FILE@/$${_FILE}/" \
			-e "s/@VERSION@/$${_VER}/" \
			-e "s/@LABEL@/$$(echo "sgd2$${_VER}" | sed 's/[\._]//' )/g" >> $@; \
	done
	for x in $$( ls super_grub_disk_* | sort ); \
	do \
		_LANG="$$( echo "$${x}" | awk 'BEGIN { FS="_"; } ; { print $$(NF-2); }' | sed 's/^./\u&/;' )"; \
		_VER="$$(echo "$${x}" | awk 'BEGIN { FS="_"; } ; { print $$NF; }' | sed 's/.img//' )"; \
		_FILE="$${x}"; \
		printf "$(configfile)" | \
		sed \
			-e "s/@SGDVERSTRING@/Super Grup Disk v1 - $${_LANG} - /" \
			-e "s/@PATH@/$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)" | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )/" \
			-e "s/@FILE@/$${_FILE}/" \
			-e "s/@VERSION@/$${_VER}/" \
			-e "s/@LABEL@/$$(echo "sgd2$${_VER}" | sed 's/[\._]//' )/g" >> $@; \
	done
	
