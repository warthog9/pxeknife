SHELL = /bin/bash

include urls
-include versions.list

ifdef CONFIG
-include $(CONFIG)
endif

ARCHS = x86_64 i386

#FILES = vmlinuz initrd.img README
FILES = vmlinuz initrd.img

.PHONY: $(ANCIENT)

.PHONY: $(VAULT)

.PHONY: $(CURRENT)

MENUTITLE = CentOS

WGETOPTS = -q -N -c

ALLVERS = $(ANCIENT) $(VAULT) $(CURRENT)
ALLVERS_32bit = $(ANCIENT) $(VAULT) $(CURRENT)
ALLVERS_64bit = $(VAULT) $(CURRENT)

configfile = label @LABEL@\n \
	     \tMENU LABEL @DISTRO@ @VERSION@ @ARCH@\n \
	     \tKERNEL @PATH@/vmlinuz \n \
	     \tAPPEND reiserfs jfs xfs initrd=@PATH@/initrd.img @METHOD@\n

export ABSPATH

ifdef CENTOSMETHOD
CONFIGMETHOD = "method=$(CENTOSMETHOD)"
else
CONFIGMETHOD = askmethod
endif


.SILENT:

.PHONY: GETVAULT GETCURRENT GETANCIENT

.INTERMEDIATE: versions.list.temp

.PHONY: clean cleanconfig cleanversion

ifdef CENTOS
buildtarget: $(CENTOS) centos.conf
else
buildtarget: $(ALLVERS) centos.conf
endif

all: $(ALLVERS)
all.i386: $(patsubst %,%.i386,$(ALLVERS))
all.x86_64: $(patsubst %,%.x86_64,$(ALLVERS))
all_vault: $(VAULT)
all_vault.i386: $(patsubst %,%.i386,$(VAULT))
all_vault.x86_64: $(patsubst %,%.x86_64,$(VAULT))
all_current: $(CURRENT)
all_current.i386: $(patsubst %,%.i386,$(CURRENT))
all_current.x86_64: $(patsubst %,%.x86_64,$(CURRENT))
all_ancient all_ancient.i386: $(ANCIENT)


clean: cleanconfig cleanversion
	-rm -rf $(ANCIENT) $(VAULT) $(CURRENT)

cleanconfig: cleanversion
	-rm -rf centos.conf

cleanversion:
	-rm -rf versions.list versions.list.*

make_statement:
	echo "----> Aquiring and Setting up Centos Network Installers"

$(ALLVERS) all: make_statement GETVAULT GETCURRENT GETANCIENT versions.list versions.list.temp

versions.list: versions.list.temp
	touch $@

versions.list.temp:
	./getversions.sh > $@
	mv $@ versions.list
	touch $@

GETVAULT: versions.list
	echo "Versions in Vault Found: $(VAULT)"

GETANCIENT: versions.list
	echo "Versions in Ancient Found: $(ANCIENT)"

GETCURRENT: GETVAULT
	echo "Versions in Current Found: $(CURRENT)"

get_statement:
	printf "\055-----> Getting Centos %-3s - %-6s\n" "$(_VER)" "$(_ARCH)"

$(ANCIENT):
	$(MAKE) -f $(MAKEFILE_LIST) $@.i386 _VER=$@

$(ALLVERS_64bit):
	$(MAKE) -f $(MAKEFILE_LIST) $@.i386 $@.x86_64 _VER=$@

$(patsubst %,%.i386,$(ALLVERS_32bit)):
ifdef _VER
	$(MAKE) -f $(MAKEFILE_LIST) $@.download _ARCH=i386
	$(MAKE) -f $(MAKEFILE_LIST) configfile
else
	$(MAKE) -f $(MAKEFILE_LIST) $@ _VER=$(shell echo $@ | sed "s/\.i386//" )
endif

$(patsubst %,%.x86_64,$(ALLVERS_64bit)):
ifdef _VER
	$(MAKE) -f $(MAKEFILE_LIST) $@.download _ARCH=x86_64
	$(MAKE) -f $(MAKEFILE_LIST) configfile
else
	$(MAKE) -f $(MAKEFILE_LIST) $@ _VER=$(shell echo $@ | sed "s/\.x86_64//" )
endif

dir:
ifdef _ARCH
ifdef _VER
	mkdir -p ${_VER}/${_ARCH}
else
	echo "Version has not been defined"
	exit 1
endif
else
	echo "Architecture has not been defined"
	exit 1
endif

$(patsubst %,%.i386.download,$(VAULT)) $(patsubst %,%.x86_64.download,$(VAULT)): dir get_statement
	for file in ${FILES}; \
	do \
		downloadlist="$${downloadlist} ${VAULTURL}/$(_VER)/os/$(_ARCH)/images/pxeboot/$${file}"; \
	done; \
	( cd $(_VER)/$(_ARCH)/; wget $(WGETOPTS) $${downloadlist} )
	$(MAKE) -f $(MAKEFILE_LIST) URL="$(VAULTURL)" MAGICURL="@URL@/@VERSION@/os/@ARCH@/" $(shell echo $@ | sed "s/\.download//" ).writeconfig


$(patsubst %,%.i386.download,$(CURRENT)) $(patsubst %,%.x86_64.download,$(CURRENT)): dir get_statement
	for file in ${FILES}; \
	do \
		downloadlist="$${downloadlist} ${CURRENTURL}/$(_VER)/os/$(_ARCH)/images/pxeboot/$${file}"; \
	done; \
	( cd $(_VER)/$(_ARCH)/; wget $(WGETOPTS) $${downloadlist} )
	$(MAKE) -f $(MAKEFILE_LIST) URL="$(CURRENTURL)" MAGICURL="@URL@/@VERSION@/os/@ARCH@/" $(shell echo $@ | sed "s/\.download//" ).writeconfig

$(patsubst %,%.i386.download,$(ANCIENT)): dir get_statement
	for file in ${FILES} initrd-everything.img; \
	do \
		downloadlist="$${downloadlist} ${ANCIENTURL}/$(_VER)/final/$(_ARCH)/images/pxeboot/$${file}"; \
	done; \
	( cd $(_VER)/$(_ARCH)/; wget $(WGETOPTS) $${downloadlist} )
	$(MAKE) -f $(MAKEFILE_LIST) URL="$(ANCIENTURL)" MAGICURL="@URL@/@VERSION@/final/@ARCH@" $(shell echo $@ | sed "s/\.download//" ).writeconfig

$(patsubst %,%.i386.writeconfig,$(ALLVERS_32bit)) $(patsubst %,%.x86_64.writeconfig,$(ALLVERS_64bit)): dir
	printf "$(configfile)" | \
	sed \
		-e 's/@PATH@/$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)" | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )\/${_VER}\/${_ARCH}/' \
		-e 's/@DISTRO@/$(MENUTITLE)/' \
		-e 's/@METHOD@/$(shell echo "${CONFIGMETHOD}" | sed -e 's/\//\\\//gi' )/' \
		-e 's/@MAGICURL@/$(shell echo "${MAGICURL}" | sed -e 's/\//\\\//gi' )/' \
		-e 's/@URL@/$(shell echo "${URL}" | sed -e 's/\//\\\//gi' )/' \
		-e 's/@VERSION@/${_VER}/' \
		-e 's/@ARCH@/${_ARCH}/' \
		-e 's/@LABEL@/$(shell echo centos${_VER}${_ARCH} | sed 's/[\._]//g' )/' > ${_VER}/${_ARCH}/sub.conf
	
configfile: centos.conf
centos.conf: $(shell find -name sub.conf)
	cat /dev/null > $@; \
	_SUBDIR="$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)" | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )"; \
	_BASEDIR="$(PXEKNIFEPREFIX)/"; \
	echo "MENU INCLUDE $${_BASEDIR}/pxeknife-gui.conf" >> $@; \
	echo "MENU TITLE $(MENUTITLE)" >> $@; \
	echo "label UpDir" >> $@; \
	echo "	MENU EXIT" >> $@; \
	echo "label blankspace" >> $@; \
	echo "	MENU LABEL " >> $@; \
	for x in $$(find -name sub.conf | sort --field-separator=/ --key=2,2r --key=3,3); \
	do \
		cat $${x} >> $@;\
	done
