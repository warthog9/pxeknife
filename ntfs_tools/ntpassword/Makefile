SHELL = /bin/bash

include urls
-include versions.list

ifdef CONFIG
-include $(CONFIG)
endif

WGETOPTS = -q -N -c
#WGETOPTS = -c


configfile = label @LABEL@\n \
	     \tMENU LABEL NT Password Recovery - @VERSION@ @ISO@\n \
	     \tkernel @MEMPATH@memdisk@ISO@\n \
	     \tappend @ISO@ initrd=@PATH@/@FILE@\n

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
	wget $(WGETOPTS) $(NTPASSWORDURLBASE)/$@
	if [[ "$(shell echo "$@" | awk 'BEGIN { FS="."; } ; { print $$NF;}')" = "zip" ]]; \
	then unzip -o $@ ;fi
	-rm -rf ntpassword.conf
	$(MAKE) $(MFLAGS) -f $(MAKEFILE_LIST) configfile

versions.list:
	./getversions.sh > $@

clean: cleanconfig
	-rm -rf cd* bd* install.bat rawrite2.exe versions.list

cleanconfig:
	-rm -rf ntpassword.conf

make_statement:
	echo "----> Aquiring and Setting up NT Password Recovery"

configfile: ntpassword.conf
ntpassword.conf:
	cat /dev/null > $@
	if [[ $$( ls | grep "^cd.*iso$$" | wc -l ) -gt 0 ]];then \
	for x in $$( ls cd*.iso | sort -n -r ); \
	do \
		_VER="$$(echo "$${x}" | sed -e 's/^[cb]d//' -e 's/.iso//' -e 's/.bin//' )"; \
		_SUBPATH="$$( echo "$(PXEKNIFEPREFIX)/$(ABSPATH)/" | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )"; \
		printf "$(configfile)" | \
		sed \
			-e "s/@MEMPATH@/@PATH@/g" \
			-e "s/@ISO@/iso/g" \
			-e "s/@PATH@/$${_SUBPATH}/g" \
			-e "s/@FILE@/$${x}/g" \
			-e "s/@VERSION@/$${_VER}/g" \
			-e "s/@LABEL@/$$(echo "ntpasswordcd$${_VER}" | sed 's/[\._]//g' )/g" >> $@; \
	done; \
	fi; \
	if [[ $$( ls | grep "^bd.*bin$$" | wc -l ) -gt 0 ]];then \
	for x in $$( ls bd*.bin | sort -n -r ); \
	do \
		_VER="$$(echo "$${x}" | sed -e 's/^[cb]d//' -e 's/.iso//' -e 's/.bin//' )"; \
		_SUBPATH="$$( echo "$(PXEKNIFEPREFIX)/$(ABSPATH)/" | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )"; \
		printf "$(configfile)" | \
		sed \
			-e "s/@MEMPATH@//g" \
			-e "s/@ISO@//g" \
			-e "s/@PATH@/$${_SUBPATH}/g" \
			-e "s/@FILE@/$${x}/g" \
			-e "s/@VERSION@/$${_VER}/g" \
			-e "s/@LABEL@/$$(echo "ntpasswordbd$${_VER}" | sed 's/[\._]//g' )/g" >> $@; \
	done; \
	fi;
