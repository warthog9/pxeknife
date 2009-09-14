SHELL = /bin/bash

include urls
-include versions.list

ifdef CONFIG
-include $(CONFIG)
endif

WGETOPTS = -q -N -c
#WGETOPTS = -c


configfile = label @LABEL@\n \
	     \tMENU LABEL Toms Root Boot @VERSION@\n \
	     \tKERNEL @PATH@/@KERNEL@ \n \
	     \tAPPEND initrd=@PATH@/@FILE@ root=100\n \

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
	printf "\055-----> Getting Toms Root Boot %-3s\n" "$@"
	wget $(WGETOPTS) $(TOMSRTBTURL)/$@
	if [[ "$(shell echo "$@" | awk 'BEGIN { FS="."; } ; { print $$NF;}')" = "bz2" ]]; \
	then tar -xjvf $@ ;fi
	-rm -rf tomsrtbt.conf
	$(MAKE) $(MFLAGS) -f $(MAKEFILE_LIST) configfile

versions.list:
	./getversions.sh > $@

clean: cleanconfig
	-rm -rf tomsrtbt* versions.list

cleanconfig:
	-rm -rf tomsrtbt.conf

make_statement:
	echo "----> Aquiring and Setting up Super Grub Disk"

configfile: tomsrtbt.conf
tomsrtbt.conf:
	cat /dev/null > $@
	for x in $$( ls | grep -v "tar\|bz2" | grep extract | sort ); \
	do \
		_VER="$$(echo "$${x}" | sed 's/\.extract//' | awk 'BEGIN { FS="-"; } ; { print $$NF; }' )"; \
		printf "$(configfile)" | \
		sed \
			-e "s/@PATH@/$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)/$${x}/" | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )/" \
			-e "s/@FILE@/$${x}\/initrd.bz2/" \
			-e "s/@KERNEL@/$${x}\/bz2bzImage/" \
			-e "s/@VERSION@/$${_VER}/" \
			-e "s/@LABEL@/$$(echo "tomsrtbt$${_VER}" | sed 's/[\._]//g' )/g" >> $@; \
	done
