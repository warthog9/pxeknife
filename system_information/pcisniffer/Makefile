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

ifdef NTPASSWORD
buildtarget: $(NTPASSWORD)
else
buildtarget: $(ALLVERS)
endif

all: $(ALLVERS) make_statement
latest: $(LATEST) make_statement

$(ALLVERS): make_statement
	printf "\055-----> Getting NT Password Recovery %-3s\n" "$@"
	wget $(WGETOPTS) $(PCISNIFFERURLBASE)/$@
	if [[ "$(shell echo "$@" | awk 'BEGIN { FS="."; } ; { print $$NF;}')" = "zip" ]]; \
	then unzip -o $@ ;fi
	-rm -rf pcisniffer.conf
	$(MAKE) $(MFLAGS) -f $(MAKEFILE_LIST) configfile

versions.list:
	./getversions.sh > $@

clean: cleanconfig
	-rm -rf disklabel.bmp pcisniffer* install* readme.txt versions.list

cleanconfig:
	-rm -rf pcisniffer.conf

make_statement:
	echo "----> Aquiring and Setting up NT Password Recovery"

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
