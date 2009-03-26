SHELL = /bin/bash

ARCHS = x86_64 i386

FILES = vmlinuz initrd.img README

ANCIENT = 2 2.1
.PHONY: $(ANCIENT)

ANCIENTURL = http://mirrors.kernel.org/centos/

VAULT = 3.1 3.3 3.4 3.5 3.6 3.7 3.8 4.0 4.0beta 4.1 4.2 4.2beta 4.3 4.4 4.5 5.0 5.1
.PHONY: $(VAULT)

VAULTURL = http://vault.centos.org/

CURRENT = 3 4 5 3.9 4.6 5.2
.PHONY: $(CURRENT)

CURRENTURL = http://mirrors.kernel.org/centos/

WGETOPTS = -q -N -c

ALLVERS = $(ANCIENT) $(VAULT) $(CURRENT)
ALLVERS_32bit = $(ANCIENT) $(VAULT) $(CURRENT)
ALLVERS_64bit = $(VAULT) $(CURRENT)

configfile = label @LABEL@\n \
	     \tMENU LABEL @DISTRO@ @VERSION@ @ARCH@\n \
	     \tKERNEL @PATH@/vmlinuz \n \
	     \tAPPEND reiserfs jfs xfs initrd=@PATH@/initrd.img\n


#.SILENT:

all: $(ALLVERS)

all_vault: $(VAULT)

all_current: $(ANCIENT) $(CURRENT)

clean:
	-rm -rf $(ANCIENT) $(VAULT) $(CURRENT)

make_statement:
	echo "----> Aquiring and Setting up Centos Network Installers"

$(ALLVERS) all: make_statement

get_statement:
	printf "\055-----> Getting Centos %-3s - %-6s\n" "$(_VER)" "$(_ARCH)"

$(ANCIENT):
	$(MAKE) -f $(MAKEFILE_LIST) $@.i386 _VER=$@

$(ALLVERS_64bit):
	$(MAKE) -f $(MAKEFILE_LIST) $@.i386 $@.x86_64 _VER=$@

$(patsubst %,%.i386,$(ALLVERS_32bit)):
ifdef _VER
	$(MAKE) -f $(MAKEFILE_LIST) $@.download _ARCH=i386
else
	$(MAKE) -f $(MAKEFILE_LIST) $@ _VER=$(shell echo $@ | sed "s/\.i386//" )
endif

$(patsubst %,%.x86_64,$(ALLVERS_64bit)):
ifdef _VER
	$(MAKE) -f $(MAKEFILE_LIST) $@.download _ARCH=x86_64
else
	$(MAKE) -f $(MAKEFILE_LIST) $@ _VER=$(shell echo $@ | sed "s/\.x86_64//" )
endif

dir: get_statement
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
	$(MAKE) -f $(MAKEFILE_LIST) $(shell echo $@ | sed "s/\.download//" ).writeconfig


$(patsubst %,%.i386.download,$(CURRENT)) $(patsubst %,%.x86_64.download,$(CURRENT)): dir get_statement
	for file in ${FILES}; \
	do \
		downloadlist="$${downloadlist} ${CURRENTURL}/$(_VER)/os/$(_ARCH)/images/pxeboot/$${file}"; \
	done; \
	( cd $(_VER)/$(_ARCH)/; wget $(WGETOPTS) $${downloadlist} )
	$(MAKE) -f $(MAKEFILE_LIST) $(shell echo $@ | sed "s/\.download//" ).writeconfig

$(patsubst %,%.i386.download,$(ANCIENT)): dir get_statement
	for file in ${FILES} initrd-everything.img; \
	do \
		downloadlist="$${downloadlist} ${ANCIENTURL}/$(_VER)/final/$(_ARCH)/images/pxeboot/$${file}"; \
	done; \
	( cd $(_VER)/$(_ARCH)/; wget $(WGETOPTS) $${downloadlist} )
	$(MAKE) -f $(MAKEFILE_LIST) $(shell echo $@ | sed "s/\.download//" ).writeconfig

$(patsubst %,%.i386.writeconfig,$(ALLVERS_32bit)) $(patsubst %,%.x86_64.writeconfig,$(ALLVERS_64bit)): dir get_statement
	printf "$(configfile)" | \
	sed \
		-e 's/@PATH@/${_VER}\/${_ARCH}/' \
		-e 's/@DISTRO@/CentOS/' \
		-e 's/@VERSION@/${_VER}/' \
		-e 's/@ARCH@/${_ARCH}/' \
		-e 's/@LABEL@/$(shell echo centos${_VER}${_ARCH} | sed 's/[\._]//g' )/' > ${_VER}/${_ARCH}/sub.conf
	
configfile centos.conf:
	cat /dev/null > centos.conf; \
	for x in $$(find -name sub.conf | sort --field-separator=/ --key=2,2r --key=3,3); \
	do \
		cat $${x} >> centos.conf;\
	done
