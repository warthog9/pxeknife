SHELL = /bin/bash

include urls
-include versions.list

ifdef CONFIG
-include $(CONFIG)
endif

WGETOPTS = -q -N -c
#WGETOPTS = -c


configfile = label @LABEL@\n \
	     \tMENU LABEL Memtest86+ @VERSION@\n \
	     \tKERNEL @PATH@/@FILE@ \n \

export ABSPATH

.SILENT:

.PHONY:

ifdef MEMTEST86PLUS
buildtarget: $(MEMTEST86PLUS)
else
buildtarget: $(LATEST)
endif

all: $(ALLVERS) make_statement
latest: $(LATEST) make_statement

$(ALLVERS): make_statement
	printf "\055-----> Getting Memtest86+ %-3s\n" "$@"
	wget $(WGETOPTS) $(MEMTEST86PLUSURL)$(shell curl --silent $(MEMTEST86PLUSURL) | grep "href=\"download/" | grep "gz" | grep "bin" | grep "$@" | tr '"' "\n" | grep download )
	gunzip -c $$( ls *$@*.bin.gz ) > $$( ls *$@*.bin.gz | sed -e 's/\.bin\.gz//' )
	$(MAKE) -f $(MAKEFILE_LIST) configfile

versions.list:
	verlist=$$( curl $(MEMTEST86PLUSURL) | grep "href=\"download/" | grep "gz" | grep "bin"| tr '"' "\n" | grep download | tr "/" "\n" | grep -v "memtest\|download" | sort -r ); printf "ALLVERS = %s\nLATEST = %s" "$$(echo "$${verlist}" | tr "\n" " ")" "$$(echo "$${verlist}" | head -n 1)" > $@

clean: cleanconfig
	-rm -rf memtest86+* versions.list

cleanconfig:
	-rm -rf memtest86+.conf

make_statement:
	echo "----> Aquiring and Setting up Memtest86+"

configfile: memtest86+.conf
memtest86+.conf:
	cat /dev/null > $@
	for x in $$( ls memtest86+* | grep -v "\.bin$$\|.gz\|\.conf$$" | sort -r ); \
	do \
		echo "Working on $${x}"; \
		_VER=$$( echo "$${x}" | sed -e 's/memtest86+-//gi' -e 's/\.bin//' ); \
		_FILE="$${x}"; \
		printf "$(configfile)" | \
		sed \
			-e "s/@PATH@/$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)" | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )/" \
			-e "s/@FILE@/$${_FILE}/" \
			-e "s/@VERSION@/$${_VER}/" \
			-e "s/@LABEL@/$$(echo "memtest86p$${_VER}" | sed 's/[\._]//' )/g" >> $@; \
	done
	
