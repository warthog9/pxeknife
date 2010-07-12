SHELL = /bin/bash

include urls
-include versions.list

ifdef CONFIG
-include $(CONFIG)
endif

WGETOPTS = -q -N -c
#WGETOPTS = -c


configfile = label @LABEL@\n \
	     \tMENU LABEL Memtest86 @VERSION@\n \
	     \tKERNEL @PATH@/@FILE@ \n \

export ABSPATH

.SILENT:

.PHONY:

.INTERMEDIATE: versions.list.temp

.PHONY: clean cleanconfig cleanversion

ifdef MEMTEST86PLUS
buildtarget: $(MEMTEST86PLUS)
else
buildtarget: $(LATEST)
endif

all: $(ALLVERS) make_statement
latest: $(LATEST) make_statement

$(ALLVERS): make_statement versions.list versions.list.temp
	printf "\055-----> Getting Memtest86+ %-3s\n" "$@"
	wget $(WGETOPTS) $(MEMTEST86BASEURL)/$(shell curl --silent -A "Mozilla/4.0" http://www.memtest86.com/download.html | grep "tar.gz" | tr " " "\n" | tr '"' "\n" | grep memtest | grep "$@" )
	tar -xzvf $$( ls *$@*.tar.gz )
	-(cd memtest86-$@;ln -s precomp.bin memtest86-$@ &> /dev/null )
	$(MAKE) -f $(MAKEFILE_LIST) configfile

versions.list: versions.list.temp
	touch $@

versions.list.temp:
	verlist=$$( curl -A "Mozilla/4.0" http://www.memtest86.com/download.html | grep "tar.gz" | tr " " "\n" | tr '"' "\n" | grep memtest | sed -e 's/memtest86-//' -e 's/\.tar\.gz//' | sort -r ); printf "ALLVERS = %s\nLATEST = %s" "$$(echo "$${verlist}" | tr "\n" " ")" "$$(echo "$${verlist}" | head -n 1)" > versions.list
	touch $@

clean: cleanconfig
	-rm -rf memtest86*

cleanconfig: cleanversion
	-rm -rf memtest86.conf

cleanversion:
	-rm -rf versions.list versions.list.*

make_statement:
	echo "----> Aquiring and Setting up Memtest86+"

configfile: memtest86.conf
memtest86.conf:
	cat /dev/null > $@
	for x in $$( find -name precomp.bin | sort -r ); \
	do \
		echo "Working on $${x}"; \
		_VER=$$( echo "$${x}" | sed -e 's/^\.//gi' -e 's/\///gi' -e 's/precomp.bin//gi' -e 's/memtest86-//' ); \
		echo "stage 1"; \
		_FILE="$$( echo "$${x}" | sed -e "s/precomp.bin/memtest86-$${_VER}/" )"; \
		echo "stage 2"; \
		printf "$(configfile)" | \
		sed \
			-e 's/@PATH@/$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)" | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )/' \
			-e "s/@FILE@/$$( echo "$${_FILE}" | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )/" \
			-e "s/@VERSION@/$${_VER}/" \
			-e "s/@LABEL@/$$( echo memtest86$${_VER} | sed 's/[\._]//g' )/" >> $@; \
	done
	
