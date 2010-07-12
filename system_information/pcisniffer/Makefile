SHELL = /bin/bash

include urls
-include versions.list

ifdef CONFIG
-include $(CONFIG)
endif

WGETOPTS = -q -N -c
#WGETOPTS = -c


configfile = label @LABEL@\n \
	     \tMENU LABEL PCI Sniffer - @VERSION@ @ISO@\n \
	     \tkernel memdisk\n \
	     \tappend initrd=@PATH@/@FILE@\n

export ABSPATH

#.SILENT:

.PHONY:

.INTERMEDIATE: versions.list.temp

.PHONY: clean cleanconfig cleanversion

ifdef NTPASSWORD
buildtarget: $(NTPASSWORD)
else
buildtarget: $(ALLVERS)
endif

all: $(ALLVERS) make_statement versions.list versions.list.temp
latest: $(LATEST) make_statement versions.list versions.list.temp

$(ALLVERS): make_statement versions.list versions.list.temp
	printf "\055-----> Getting NT Password Recovery %-3s\n" "$@"
	wget $(WGETOPTS) $(PCISNIFFERURLBASE)/$@
	if [[ "$(shell echo "$@" | awk 'BEGIN { FS="."; } ; { print $$NF;}')" = "zip" ]]; \
	then unzip -o $@ ;fi
	-rm -rf pcisniffer.conf
	$(MAKE) $(MFLAGS) -f $(MAKEFILE_LIST) configfile

clean: cleanconfig cleanversion
	-rm -rf disklabel.bmp pcisniffer* install* readme.txt

cleanconfig:
	-rm -rf pcisniffer.conf

cleanversion:
	-rm -rf versions.list versions.list.*

make_statement:
	echo "----> Aquiring and Setting up NT Password Recovery"


versions.list: versions.list.temp
	touch $@

versions.list.temp:
	./getversions.sh > $@
	mv $@ versions.list
	touch $@

configfile: pcisniffer.conf
pcisniffer.conf:
	cat /dev/null > $@
	for x in $$( ls *.img | sort -n -r ); \
	do \
		_VER="$(PCISNIFFER_VER)"; \
		_SUBPATH="$$( echo "$(PXEKNIFEPREFIX)/$(ABSPATH)/" | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )"; \
		printf "$(configfile)" | \
		sed \
			-e "s/@MEMPATH@/@PATH@/g" \
			-e "s/@ISO@//g" \
			-e "s/@PATH@/$${_SUBPATH}/g" \
			-e "s/@FILE@/$${x}/g" \
			-e "s/@VERSION@/$${_VER}/g" \
			-e "s/@LABEL@/$$(echo "pcisniffer$${_VER}" | sed 's/[\._]//g' )/g" >> $@; \
	done; \
