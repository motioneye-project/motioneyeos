#############################################################
#
# Setup the kernel headers.  I include a generic package of
# kernel headers here, so you shouldn't need to include your
# own.  Be aware these kernel headers _will_ get blown away
# by a 'make clean' so don't put anything sacred in here...
#
#############################################################
ifneq ($(filter $(TARGETS),kernel-headers),)
DEFAULT_KERNEL_HEADERS:=$(strip $(DEFAULT_KERNEL_HEADERS))

LINUX_SITE:=127.0.0.1
LINUX_SOURCE:=unspecified-kernel-headers

ifeq ("$(strip $(DEFAULT_KERNEL_HEADERS))","2.4.25")
VERSION:=2
PATCHLEVEL:=4
SUBLEVEL:=25
LINUX_SITE:=http://www.uclibc.org/downloads/toolchain
LINUX_SOURCE:=linux-libc-headers-2.4.25.tar.bz2
LINUX_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.4.25
endif

ifeq ("$(strip $(DEFAULT_KERNEL_HEADERS))","2.4.27")
VERSION:=2
PATCHLEVEL:=4
SUBLEVEL:=25
LINUX_SITE:=http://www.uclibc.org/downloads/toolchain
LINUX_SOURCE:=linux-libc-headers-2.4.27.tar.bz2
LINUX_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.4.27
endif

ifeq ("$(strip $(DEFAULT_KERNEL_HEADERS))","2.6.7")
VERSION:=2
PATCHLEVEL:=6
SUBLEVEL:=7
LINUX_SITE:=http://ep09.pld-linux.org/~mmazur/linux-libc-headers/
LINUX_SOURCE:=linux-libc-headers-2.6.7.0.tar.bz2
LINUX_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.6.7.0
endif

ifeq ("$(strip $(DEFAULT_KERNEL_HEADERS))","2.6.8")
VERSION:=2
PATCHLEVEL:=6
SUBLEVEL:=8
LINUX_SITE:=http://ep09.pld-linux.org/~mmazur/linux-libc-headers/
LINUX_SOURCE:=linux-libc-headers-2.6.8.0.tar.bz2
LINUX_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.6.8.0
endif

LINUX_VERSION:=$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)

LINUX_DIR:=$(TOOL_BUILD_DIR)/linux

$(DL_DIR)/$(LINUX_SOURCE):
	mkdir -p $(DL_DIR)
	$(WGET) -P $(DL_DIR) $(LINUX_SITE)/$(LINUX_SOURCE)

$(LINUX_DIR)/.unpacked: $(DL_DIR)/$(LINUX_SOURCE)
	mkdir -p $(TOOL_BUILD_DIR)
	bzcat $(DL_DIR)/$(LINUX_SOURCE) | tar -C $(TOOL_BUILD_DIR) -xvf -
ifneq ($(LINUX_UNPACK_DIR),$(LINUX_DIR))
	mv $(LINUX_UNPACK_DIR) $(LINUX_DIR)
endif
	touch $(LINUX_DIR)/.unpacked

$(LINUX_DIR)/.patched: $(LINUX_DIR)/.unpacked
	$(SOURCE_DIR)/patch-kernel.sh $(LINUX_DIR) $(SOURCE_DIR) linux-libc-headers-$(LINUX_VERSION)-\*.patch
	touch $(LINUX_DIR)/.patched

$(LINUX_DIR)/.configured: $(LINUX_DIR)/.patched
	rm -f $(LINUX_DIR)/include/asm
	@if [ ! -f $(LINUX_DIR)/Makefile ] ; then \
	    echo -e "VERSION = $(VERSION)\nPATCHLEVEL = $(PATCHLEVEL)\n" > \
		    $(LINUX_DIR)/Makefile; \
	    echo -e "SUBLEVEL = $(SUBLEVEL)\nEXTRAVERSION =\n" >> \
		    $(LINUX_DIR)/Makefile; \
	    echo -e "KERNELRELEASE=\$$(VERSION).\$$(PATCHLEVEL).\$$(SUBLEVEL)\$$(EXTRAVERSION)" >> \
		    $(LINUX_DIR)/Makefile; \
	fi;
	@if [ "$(ARCH)" = "powerpc" ];then \
	    (cd $(LINUX_DIR)/include; ln -fs asm-ppc$(NOMMU) asm;) \
	elif [ "$(ARCH)" = "mips" ];then \
	    (cd $(LINUX_DIR)/include; ln -fs asm-mips$(NOMMU) asm;) \
	elif [ "$(ARCH)" = "mipsel" ];then \
	    (cd $(LINUX_DIR)/include; ln -fs asm-mips$(NOMMU) asm;) \
	elif [ "$(ARCH)" = "arm" ];then \
	    (cd $(LINUX_DIR)/include; ln -fs asm-arm$(NOMMU) asm; \
	     cd asm; \
	     if [ ! -L proc ] ; then \
	     ln -fs proc-armv proc; \
	     ln -fs arch-ebsa285 arch; fi); \
	elif [ "$(ARCH)" = "armeb" ];then \
	    (cd $(LINUX_DIR)/include; ln -fs asm-arm$(NOMMU) asm; \
	     cd asm; \
	     if [ ! -L proc ] ; then \
	     ln -fs proc-armv proc; \
	     ln -fs arch-ebsa285 arch; fi); \
	elif [ "$(ARCH)" = "cris" ];then \
	    (cd $(LINUX_DIR)/include; ln -fs asm-cris asm;) \
	else \
	    (cd $(LINUX_DIR)/include; ln -fs asm-$(ARCH)$(NOMMU) asm;) \
	fi
	touch $(LINUX_DIR)/include/linux/autoconf.h;
	touch $(LINUX_DIR)/.configured

$(LINUX_KERNEL): $(LINUX_DIR)/.configured

kernel-headers: $(LINUX_DIR)/.configured

kernel-headers-source: $(DL_DIR)/$(LINUX_SOURCE)

kernel-headers-clean: clean
	rm -f $(LINUX_KERNEL)
	rm -rf $(LINUX_DIR)

kernel-headers-dirclean:
	rm -rf $(LINUX_DIR)

endif
