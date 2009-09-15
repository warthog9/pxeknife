SHELL = /bin/bash

include urls
-include versions.list

ifdef CONFIG
-include $(CONFIG)
endif

ARCHS = amd64 i386

FILES = vmlinuz initrd.img

MENUTITLE = Ubuntu

WGETOPTS = --reject ".iso,\?" --cut-dirs=2 -e robots=off -nH -np --mirror -q -N -c
#WGETOPTS = --reject ".iso,\?" --cut-dirs=2 -e robots=off -nH -np --mirror -N -c

#configfile = label @LABEL@\n \
#	     \tMENU LABEL @DISTRO@ @VERSION@ @ARCH@\n \
#	     \tKERNEL @SYSMENU@ \n \
#	     \tAPPEND @PATH@\n
configfile = MENU INCLUDE @PATH@ @DISTRO@ @VERSION@ @ARCH@\n

export ABSPATH

ifdef UBUNTUMETHOD
CONFIGMETHOD = "method=$(UBUNTUMETHOD)"
else
CONFIGMETHOD = askmethod
endif


#.SILENT:

.PHONY: ARCHIVE ARCHIVECORE CURRENT CURRENTTEST DEVELOPMENT

ifdef UBUNTU
buildtarget: $(UBUNTU) ubuntu.conf
else
buildtarget: $(ALLVERS) ubuntu.conf
endif

all: $(ALLVERS)
all.i386: $(patsubst %,%.i386,$(ALLVERS))
all.amd64:$(patsubst %,%.amd64,$(ALLVERS))
all.x86_64: all.amd64
current: $(CURRENT)
current.i386: $(patsubst %,%.i386,$(CURRENT))
current.amd64: $(patsubst %,%.amd64,$(CURRENT))
current.x86_64: current.amd64
archive: $(ARCHIVE)
archive.i386: $(patsubst %,%.i386,$(ARCHIVE))
archive.amd64: $(patsubst %,%.amd64,$(ARCHIVE))
archive.x86_64: archive.amd64

clean:
	-rm -rf $(ALLVERS) ubuntu.conf versions.list

make_statement:
	echo "----> Aquiring and Setting up $(MENUTITLE) Network Installers"

$(ALLVERS) all: make_statement ARCHIVE CURRENT

versions.list:
	./getversions.sh > $@

ARCHIVE CURRENT : versions.list
	echo "Versions in Vault Found: $($@)"


get_statement:
	printf "\055-----> Getting $(MENUTITLE) %-3s - %-6s\n" "$(_VER)" "$(_ARCH)"


$(ALLVERS):
	$(MAKE) -f $(MAKEFILE_LIST) $@.i386 $@.amd64 _VER=$@

$(patsubst %,%.i386,$(ALLVERS)):
ifdef _VER
	$(MAKE) -f $(MAKEFILE_LIST) $@.download _ARCH=i386
	$(MAKE) -f $(MAKEFILE_LIST) configfile
else
	$(MAKE) -f $(MAKEFILE_LIST) $@ _VER=$(shell echo $@ | sed "s/\.i386//" )
endif

$(patsubst %,%.x86_64,$(ALLVERS)): $(patsubst %.x86_64,%.amd64,$@)

$(patsubst %,%.amd64,$(ALLVERS)):
ifdef _VER
	$(MAKE) -f $(MAKEFILE_LIST) $@.download _ARCH=amd64
	$(MAKE) -f $(MAKEFILE_LIST) configfile
else
	$(MAKE) -f $(MAKEFILE_LIST) $@ _VER=$(shell echo $@ | sed "s/\.amd64//" )
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

$(patsubst %,%.i386.download,$(ARCHIVE)) $(patsubst %,%.amd64.download,$(ARCHIVE)): dir get_statement
	wget $(WGETOPTS) "${ARCHIVEURL}/$(_VER)/main/installer-$(_ARCH)/current/images/netboot/"
	#find "$(_VER)/main/installer-$(_ARCH)" -type f | grep "$(_ARCH)/netboot" | xargs sed -i 's/[ \t]*ubuntu-installer/$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)/$(_VER)/main/installer-$(_ARCH)/netboot/ubuntu-installer" | sed -e 's/\//\\\//gi' )/gi'
	find "$(_VER)/main/installer-$(_ARCH)" -type f | xargs sed -i 's/\([^/]\)ubuntu-installer/\1$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)/$(_VER)/main/installer-$(_ARCH)/netboot/ubuntu-installer" | sed -e 's/\//\\\//gi' )/gi'
	-( cd $(_VER)/main/installer-$(_ARCH);ln -s current/images/netboot . )
	$(MAKE) -f $(MAKEFILE_LIST) $(shell echo $@ | sed "s/\.download//" ).writeconfig

$(patsubst %,%.i386.download,$(CURRENT)) $(patsubst %,%.amd64.download,$(CURRENT)): dir get_statement
	wget $(WGETOPTS) "${CURRENTURL}/$(_VER)/main/installer-$(_ARCH)/current/images/netboot/"
	#find "$(_VER)/main/installer-$(_ARCH)" -type f | xargs sed -i 's/[ \t]*ubuntu-installer/$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)/$(_VER)/main/installer-$(_ARCH)/netboot/ubuntu-installer/" | sed -e 's/\//\\\//gi' )/gi'
	find "$(_VER)/main/installer-$(_ARCH)" -type f | xargs sed -i 's/\([^/]\)ubuntu-installer/\1$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)/$(_VER)/main/installer-$(_ARCH)/netboot/ubuntu-installer" | sed -e 's/\//\\\//gi' )/gi'
	-( cd $(_VER)/main/installer-$(_ARCH);ln -s current/images/netboot . )
	$(MAKE) -f $(MAKEFILE_LIST) $(shell echo $@ | sed "s/\.download//" ).writeconfig

		#-e 's/@PATH@/$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)/" | sed -e 's/\/\//\//gi' -e s'/\//\\\//gi' )\/$(shell find -L . -name default | grep "$(_VER)" | grep "$(_ARCH)/netboot" | sed -e 's/\//\\\//gi' -e 's/\/\//\//gi' | awk '{print $1; }' )/' 
$(patsubst %,%.i386.writeconfig,$(ALLVERS)) $(patsubst %,%.amd64.writeconfig,$(ALLVERS)): dir
	printf "$(configfile)" | \
	sed \
		-e 's/@DISTRO@/$(MENUTITLE)/' \
		-e 's/@VERSION@/${_VER}/' \
		-e 's/@ARCH@/${_ARCH}/' \
		-e 's/@SYSMENU@/menu.c32/' \
		-e 's/@LABEL@/$(shell echo ubuntu${_VER}${_ARCH} | sed 's/[\._]//g' )/' \
		-e 's/@PATH@/$(shell echo "$(PXEKNIFEPREFIX)/$(ABSPATH)/$$(find -L "$(_VER)/main/installer-$(_ARCH)" -name default | grep -v "current\|netboot/ubuntu")" | sed -e 's/\/\//\//gi' -e 's/\//\\\//gi' )/' \
		-e 's/\/\.\//\//gi' -e 's/\/\//\//gi' > ${_VER}/${_ARCH}/sub.conf
	
configfile: ubuntu.conf
ubuntu.conf: $(shell find -name sub.conf)
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
