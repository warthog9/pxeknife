SHELL = /bin/bash

include urls
-include versions.list

ifdef CONFIG
-include $(CONFIG)
endif

ARCHS = x86_64 i386

FILES = vmlinuz initrd.img

MENUTITLE = Fedora

WGETOPTS = -q -N -c
#WGETOPTS = -c


configfile = label @LABEL@\n \
	     \tMENU LABEL @DISTRO@ @VERSION@ @ARCH@\n \
	     \tKERNEL @PATH@/vmlinuz \n \
	     \tAPPEND reiserfs jfs xfs initrd=@PATH@/initrd.img @METHOD@\n

export ABSPATH

ifdef FEDORAMETHOD
CONFIGMETHOD = "method=$(FEDORAMETHOD)"
else
CONFIGMETHOD = askmethod
endif


.SILENT:

.PHONY: ARCHIVE ARCHIVECORE CURRENT CURRENTTEST DEVELOPMENT

ifdef FEDORA
buildtarget: $(FEDORA) fedora.conf
else
buildtarget: $(ALLVERS) fedora.conf
endif

all: $(ALLVERS)
all.i386: $(patsubst %,%.i386,$(ALLVERS))
all.x86_64: $(patsubst %,%.x86_64,$(ALLVERS))
all_archive: $(ARCHIVECORE) $(ARCHIVE)
all_archive.i386: $(patsubst %,%.i386,$(ARCHIVECORE)) $(patsubst %,%.i386,$(ARCHIVE))
all_archive.x86_64: $(patsubst %,%.x86_64,$(ARCHIVECORE)) $(patsubst %,%.x86_64,$(ARCHIVE)) 
all_current: $(CURRENT)
all_current.i386: $(patsubst %,%.i386,$(CURRENT))
all_current.x86_64: $(patsubst %,%.x86_64,$(CURRENT))


clean:
	-rm -rf $(ALLVERS) fedora.conf versions.list

make_statement:
	echo "----> Aquiring and Setting up Centos Network Installers"

$(ALLVERS) all: make_statement ARCHIVE ARCHIVECORE CURRENT CURRENTTEST DEVELOPMENT

versions.list:
	./getversions.sh > $@

ARCHIVE ARCHIVECORE CURRENT CURRENTTEST DEVELOPMENT: versions.list
	echo "Versions in $@ Found: $($@)"


get_statement:
	printf "\055-----> Getting Fedora %-3s - %-6s\n" "$(_VER)" "$(_ARCH)"

1:
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

$(patsubst %,%.i386.download,$(ARCHIVECORE)) $(patsubst %,%.x86_64.download,$(ARCHIVECORE)): dir get_statement
	for file in ${FILES}; \
	do \
		downloadlist="$${downloadlist} ${ARCHIVECOREURL}/$(_VER)/$(_ARCH)/os/images/pxeboot/$${file}"; \
	done; \
	( cd $(_VER)/$(_ARCH)/; wget $(WGETOPTS) $${downloadlist} )
	$(MAKE) -f $(MAKEFILE_LIST) URL="$(ARCHIVECOREURL)" MAGICURL="@URL@/@VERSION@/@ARCH@/os/" $(shell echo $@ | sed "s/\.download//" ).writeconfig

$(patsubst %,%.i386.download,$(ARCHIVE)) $(patsubst %,%.x86_64.download,$(ARCHIVE)): dir get_statement
	for file in ${FILES}; \
	do \
		downloadlist="$${downloadlist} ${ARCHIVEURL}/$(_VER)/Fedora/$(_ARCH)/os/images/pxeboot/$${file}"; \
	done; \
	( cd $(_VER)/$(_ARCH)/; wget $(WGETOPTS) $${downloadlist} )
	$(MAKE) -f $(MAKEFILE_LIST) URL="$(ARCHIVEURL)" MAGICURL="@URL@/@VERSION@/Fedora/@ARCH@/os/" $(shell echo $@ | sed "s/\.download//" ).writeconfig

$(patsubst %,%.i386.download,$(CURRENTTEST)) $(patsubst %,%.x86_64.download,$(CURRENTTEST)): dir get_statement
	for file in ${FILES}; \
	do \
		downloadlist="$${downloadlist} ${CURRENTTESTURL}/$(_VER)/Fedora/$(_ARCH)/os/images/pxeboot/$${file}"; \
	done; \
	( cd $(_VER)/$(_ARCH)/; wget $(WGETOPTS) $${downloadlist} )
	$(MAKE) -f $(MAKEFILE_LIST) URL="$(CURRENTTESTURL)" MAGICURL="@URL@/@VERSION@/Fedora/@ARCH@/os/" $(shell echo $@ | sed "s/\.download//" ).writeconfig

$(patsubst %,%.i386.download,$(CURRENT)) $(patsubst %,%.x86_64.download,$(CURRENT)): dir get_statement
	for file in ${FILES}; \
	do \
		downloadlist="$${downloadlist} ${CURRENTURL}/$(_VER)/Fedora/$(_ARCH)/os/images/pxeboot/$${file}"; \
	done; \
	( cd $(_VER)/$(_ARCH)/; wget $(WGETOPTS) $${downloadlist} )
	$(MAKE) -f $(MAKEFILE_LIST) URL="$(CURRENTURL)" MAGICURL="@URL@/@VERSION@/Fedora/@ARCH@/os/" $(shell echo $@ | sed "s/\.download//" ).writeconfig

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
		-e 's/@LABEL@/$(shell echo fedora${_VER}${_ARCH} | sed 's/[\._]//g' )/' > ${_VER}/${_ARCH}/sub.conf
	
configfile: fedora.conf
fedora.conf: $(shell find -name sub.conf)
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
