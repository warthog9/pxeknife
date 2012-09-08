SHELL = /bin/bash

include urls
-include versions.list

ifdef CONFIG
-include $(CONFIG)
endif

ARCHS = x86_64 i686

#FILES = vmlinuz initrd.img README
FILES = vmlinuz initrd.img

.PHONY: $(ARCHIVE)

.PHONY: $(CURRENT)

MENUTITLE = Archlinux

WGETOPTS = -q -N -c
#WGETOPTS = -N -c

FILTERVERS = 2002.03

ALLVERS = $(ARCHIVE) $(CURRENT)
ALLVERS_32bit = $(ARCHIVE) $(CURRENT)
ALLVERS_64bit = $(filter-out $(FILTERVERS), $(ARCHIVE) $(CURRENT) )

configfile = label @LABEL@\n \
	     \tMENU LABEL @DISTRO@ @VERSION@ @ARCH@\n \
	     \tKERNEL memdisk \n \
	     \tAPPEND iso initrd=@PATH@/@FILENAME@\n

export ABSPATH

ifdef ARCHLINUXMETHOD
CONFIGMETHOD = "method=$(ARCHLINUXMETHOD)"
else
CONFIGMETHOD = askmethod
endif


.SILENT:

.PHONY: GETARCHIVE GETCURRENT

.INTERMEDIATE: versions.list.temp

.PHONY: clean cleanconfig cleanversion

ifdef ARCHLINUX
buildtarget: $(ARCHLINUX) archlinux.conf
else
buildtarget: $(ALLVERS) archlinux.conf
endif

all: $(ALLVERS)
all.i686: $(patsubst %,%.i686,$(ALLVERS))
all.x86_64: $(filter-out $(FILTERVERS), $(patsubst %,%.x86_64,$(ALLVERS)) )
all_vault: $(ARCHIVE)
all_vault.i686: $(patsubst %,%.i686,$(ARCHIVE))
all_vault.x86_64: $(filter-out $(FILTERVERS), $(patsubst %,%.x86_64,$(ARCHIVE)) )
all_current: $(CURRENT)
all_current.i686: $(patsubst %,%.i686,$(CURRENT))
all_current.x86_64: $(filter-out $(FILTERVERS), $(patsubst %,%.x86_64,$(CURRENT)) )


clean: cleanconfig cleanversion
	-rm -rf $(ARCHIVE) $(CURRENT)

cleanconfig: cleanversion
	-rm -rf archlinux.conf

cleanversion:
	-rm -rf versions.list versions.list.*

make_statement:
	echo "----> Aquiring and Setting up Archlinux Network Installers"

$(ALLVERS) all: make_statement GETARCHIVE GETCURRENT versions.list versions.list.temp

versions.list: versions.list.temp
	touch versions.list

versions.list.temp:
	./getversions.sh > $@
	mv $@ versions.list
	touch $@

GETARCHIVE: versions.list
	echo "Versions in Vault Found: $(ARCHIVE)"

GETCURRENT: GETARCHIVE
	echo "Versions in Current Found: $(CURRENT)"

get_statement:
	printf "\055-----> Getting Archlinux %-3s - %-6s\n" "$(_VER)" "$(_ARCH)"

$(ALLVERS_64bit):
	$(MAKE) -f $(MAKEFILE_LIST) $@.i686 $@.x86_64 _VER=$@

$(patsubst %,%.i686,$(ALLVERS_32bit)):
ifdef _VER
	$(MAKE) -f $(MAKEFILE_LIST) $@.download _ARCH=i686
	$(MAKE) -f $(MAKEFILE_LIST) configfile
else
	$(MAKE) -f $(MAKEFILE_LIST) $@ _VER=$(shell echo $@ | sed "s/\.i686//" )
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

$(patsubst %,%.i686.download,$(ARCHIVE)) $(patsubst %,%.x86_64.download,$(ARCHIVE)): dir get_statement
	if [[ "$$( echo "$(_VER)" | sed -e 's/\.//g' -e 's/^0*//g' )" -gt "200000" && "$$( echo "$(_VER)" | sed -e 's/\.//g' -e 's/^0*//g' )" -le "200803" ]];then \
		download_file="${ARCHIVEURL}/$(_VER)/$(_ARCH)/$$( perl getlinks.pl "${ARCHIVEURL}/$(_VER)/$(_ARCH)/" | grep "\(ftp\|netinstall\|dual\).iso$$" )"; \
	elif [[ "$$( echo "$(_VER)" | sed -e 's/\.//g' -e 's/^0*//g' )" -ge "200806" ]];then \
		download_file="${ARCHIVEURL}/$(_VER)/$$( perl getlinks.pl "${ARCHIVEURL}/$(_VER)/" | grep "\(ftp\|netinstall\|dual\)-$(_ARCH).iso$$" )"; \
	else \
		download_file="${ARCHIVEURL}/arch-$(_VER)-ftp-$(_ARCH).iso"; \
	fi; \
	( cd $(_VER)/$(_ARCH)/; wget $(WGETOPTS) "$${download_file}"; )
	$(MAKE) -f $(MAKEFILE_LIST) URL="$(ARCHIVEURL)" MAGICURL="@URL@/@VERSION@/os/@ARCH@/" $(shell echo $@ | sed "s/\.download//" ).writeconfig


$(patsubst %,%.i686.download,$(CURRENT)) $(patsubst %,%.x86_64.download,$(CURRENT)): dir get_statement
	if [[ "$$( echo "$(_VER)" | sed -e 's/\.//g' -e 's/^0*//g' )" -lt "200806" && "$$( echo "$(_VER)" | sed -e 's/\.//g' -e 's/^0*//g' )" -gt "200203" ]];then \
		download_file="${CURRENTURL}/$(_VER)/$(_ARCH)/$$( perl getlinks.pl "${CURRENTURL}/$(_VER)/$(_ARCH)/" | grep "\(ftp\|netinstall\|dual\)\(-$(_ARCH)\)*.iso$$" )"; \
	else \
		download_file="${CURRENTURL}/$(_VER)/$$( perl getlinks.pl "${CURRENTURL}/$(_VER)/" | grep "\(full\|ftp\|netinstall\|dual\)\(-$(_ARCH)\)*.iso$$" )"; \
	fi; \
	( cd $(_VER)/$(_ARCH)/; wget $(WGETOPTS) "$${download_file}" )
	$(MAKE) -f $(MAKEFILE_LIST) URL="$(CURRENTURL)" MAGICURL="@URL@/@VERSION@/os/@ARCH@/" $(shell echo $@ | sed "s/\.download//" ).writeconfig

$(patsubst %,%.i686.writeconfig,$(ALLVERS_32bit)) $(patsubst %,%.x86_64.writeconfig,$(ALLVERS_64bit)): dir
	printf "$(configfile)" | \
	sed \
		-e 's/@BASEPATH@/$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)" | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )\//' \
		-e 's/@PATH@/$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)" | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )\/${_VER}\/${_ARCH}/' \
		-e 's/@DISTRO@/$(MENUTITLE)/' \
		-e 's/@METHOD@/$(shell echo "${CONFIGMETHOD}" | sed -e 's/\//\\\//gi' )/' \
		-e 's/@MAGICURL@/$(shell echo "${MAGICURL}" | sed -e 's/\//\\\//gi' )/' \
		-e 's/@URL@/$(shell echo "${URL}" | sed -e 's/\//\\\//gi' )/' \
		-e 's/@VERSION@/${_VER}/' \
		-e 's/@ARCH@/${_ARCH}/' \
		-e 's/@FILENAME@/$(shell basename $$( ls ${_VER}/${_ARCH}/*.iso ) )/' \
		-e 's/@LABEL@/$(shell echo archlinux${_VER}${_ARCH} | sed 's/[\._]//g' )/' > ${_VER}/${_ARCH}/sub.conf
	
configfile: archlinux.conf
archlinux.conf: $(shell find -name sub.conf)
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
