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

.PHONY: clean cleanconfig cleanversion

.INTERMEDIATE: versions.list.temp

ifdef TOMSRTBT
buildtarget: $(TOMSRTBT)
else
buildtarget: $(ALLVERS)
endif

all: $(ALLVERS) make_statement
latest: $(LATEST) make_statement

$(ALLVERS): make_statement versions.list versions.list.temp
	printf "\055-----> Getting Toms Root Boot %-3s\n" "$@"
	wget $(WGETOPTS) $(TOMSRTBTURL)/$@
	if [[ "$(shell echo "$@" | awk 'BEGIN { FS="."; } ; { print $$NF;}')" = "bz2" ]]; \
	then tar -xjvf $@ ;fi
	-rm -rf tomsrtbt.conf
	$(MAKE) $(MFLAGS) -f $(MAKEFILE_LIST) configfile

versions.list: versions.list.temp
	touch versions.list

versions.list.temp:
	./getversions.sh > $@
	mv $@ versions.list
	touch $@

clean: cleanconfig cleanversion
	-rm -rf tomsrtbt*

cleanconfig: cleanversion
	-rm -rf tomsrtbt.conf

cleanversion:
	-rm -rf versions.list versions.list.*

make_statement:
	echo "----> Aquiring and Setting up Toms Root & Boot"

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
