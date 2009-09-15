SHELL = /bin/bash

include urls
-include versions.list

ifdef CONFIG
-include $(CONFIG)
endif

WGETOPTS = -q -N -c
#WGETOPTS = -c


#configfile = label @LABEL@\n \
#	     \tMENU LABEL Recovery Is Possible (RIP) - @VERSION@\n \
#	     \tMENU INCLUDE @PATH@/@FILE@ RIP - @VERSION@\n \
#
configfile = MENU INCLUDE @PATH@/@FILE@ RIP - @VERSION@

export ABSPATH

#.SILENT:

.PHONY:

ifdef TOMSRTBT
buildtarget: $(TOMSRTBT)
else
buildtarget: $(ALLVERS)
endif

all: $(ALLVERS) make_statement
latest: $(LATEST) make_statement

$(ALLVERS): make_statement
	printf "\055-----> Getting Recovery Is Possible (RIP) %-3s\n" "$@"
	wget $(WGETOPTS) $(RIPURL)/$@
	if [[ "$(shell echo "$@" | awk 'BEGIN { FS="."; } ; { print $$NF;}')" = "zip" ]]; \
	then unzip -o $@ ;fi
	-rm -rf rip.conf
	$(MAKE) $(MFLAGS) -f $(MAKEFILE_LIST) configfile

versions.list:
	./getversions.sh > $@

clean: cleanconfig
	-rm -rf rip* RIP* tftpboot versions.list

cleanconfig:
	-rm -rf rip.conf

make_statement:
	echo "----> Aquiring and Setting up Recovery Is Possible (RIP)"

configfile: rip.conf
rip.conf:
	cat /dev/null > $@
	for x in $$( find -name default ); \
	do \
		_VER="$$(cat "$${x}" | grep "MENU TITLE" | awk '{ print $$NF; }' | sed 's/[\r\n]*//g' )"; \
		_MENUTITLE="$$(cat "$${x}" | grep "MENU TITLE" )"; \
		_TOPHALF="$$( grep -n "LABEL Boot Memory Tester" "$${x}" | awk 'BEGIN { FS=":"; } ; { print $$1; }' )"; \
		echo "file: $${x} | ver: $${_VER} | tophalf: $${_TOPHALF}"; \
		let "_TOPHALF = _TOPHALF - 1"; \
		_SUBPATH="$$( dirname $$( dirname "$(PXEKNIFEPREFIX)/$(ABSPATH)/$${x}/" ) | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )"; \
		printf "$(configfile)" | \
		sed \
			-e "s/@PATH@/$${_SUBPATH}/g" \
			-e "s/@FILE@/rip@VERSION@.conf/g" \
			-e "s/@VERSION@/$${_VER}/g" \
			-e "s/@LABEL@/$$(echo "rip$${_VER}" | sed 's/[\._]//g' )/g" >> $@; \
		head -n +$${_TOPHALF} $${x} | grep -v "^DEFAULT\|^PROMPT\|^MENU TITLE" | sed \
			-e "s/KERNEL kernel/KERNEL $${_SUBPATH}\/kernel/g" \
			-e "s/initrd=rootfs.cgz/initrd=$${_SUBPATH}\/rootfs.cgz/g" > "$$( echo "$$( dirname "$$( dirname "$${x}" )" )/rip$${_VER}.conf" )"; \
	done
