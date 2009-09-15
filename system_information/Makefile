SHELL = /bin/bash

#.SILENT:

ifdef CONFIG
include $(CONFIG)
NEWCONFIG="../$(CONFIG)"
else
NEWCONFIG=""
endif

ifdef PCISNIFFER
DIRS := $(DIRS) pcisniffer
endif

configfile = label @LABEL@\n \
	     \tMENU LABEL @DISTRO@ \n \
	     \tKERNEL menu.c32 \n \
	     \tAPPEND @CONFIGFILE@\n

all: make_statement configfile $(DIRS)

make_statement:
	echo "--> System Information"

configfile: $(DIRS) system_information.conf
system_information.conf: $(subst %,%/%.conf,$(DIRS))
	cat /dev/null > $@; \
        for x in $(DIRS); \
        do \
		if [[ -e "$${x}/$${x}.conf" ]]; \
		then \
			echo "~~ $${x}"; \
			printf "$(configfile)" | \
		        sed \
		                -e "s/@DISTRO@/$${x}/" \
		                -e "s/@CONFIGFILE@/$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)" | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )\/$${x}\/$${x}.conf/" \
		                -e "s/@LABEL@/$${x}/" >> $@; \
		fi \
        done

$(DIRS): make_statement
	$(MAKE) $(MFLAGS) ABSPATH="$(ABSPATH)/$@" CONFIG="$(NEWCONFIG)" -C $@ -f Makefile

clean: make_statement $(patsubst %,%.clean,$(DIRS))
	-rm -rf *.conf

$(patsubst %,%.clean,$(DIRS)):
	$(MAKE) $(MFLAGS) ABSPATH="$(ABSPATH)/$@" CONFIG="$(NEWCONFIG)" -C $(patsubst %.clean,%,$@) -f Makefile clean

