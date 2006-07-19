#############################################################
#
# Setup the kernel headers.  I include a generic package of
# kernel headers here, so you shouldn't need to include your
# own.  Be aware these kernel headers _will_ get blown away
# by a 'make clean' so don't put anything sacred in here...
#
#############################################################
DEFAULT_KERNEL_HEADERS:=$(strip $(subst ",, $(BR2_DEFAULT_KERNEL_HEADERS)))
#"
LINUX_HEADERS_SITE:=127.0.0.1
LINUX_HEADERS_SOURCE:=unspecified-kernel-headers
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-null

ifeq ("$(strip $(DEFAULT_KERNEL_HEADERS))","2.4.25")
VERSION:=2
PATCHLEVEL:=4
SUBLEVEL:=25
LINUX_HEADERS_SITE:=http://www.uclibc.org/downloads/toolchain
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.4.25.tar.bz2
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.4.25
endif

ifeq ("$(strip $(DEFAULT_KERNEL_HEADERS))","2.4.27")
VERSION:=2
PATCHLEVEL:=4
SUBLEVEL:=27
LINUX_HEADERS_SITE:=http://www.uclibc.org/downloads/toolchain
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.4.27.tar.bz2
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.4.27
endif

ifeq ("$(strip $(DEFAULT_KERNEL_HEADERS))","2.4.29")
VERSION:=2
PATCHLEVEL:=4
SUBLEVEL:=29
LINUX_HEADERS_SITE:=http://www.uclibc.org/downloads/toolchain
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.4.29.tar.bz2
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.4.29
endif

ifeq ("$(strip $(DEFAULT_KERNEL_HEADERS))","2.4.31")
VERSION:=2
PATCHLEVEL:=4
SUBLEVEL:=31
LINUX_HEADERS_SITE:=http://www.uclibc.org/downloads/toolchain
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.4.31.tar.bz2
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.4.31
endif

ifeq ("$(strip $(DEFAULT_KERNEL_HEADERS))","2.6.9")
VERSION:=2
PATCHLEVEL:=6
SUBLEVEL:=9
LINUX_HEADERS_SITE:=http://ep09.pld-linux.org/~mmazur/linux-libc-headers/
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.6.9.1.tar.bz2
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.6.9.1
endif

ifeq ("$(strip $(DEFAULT_KERNEL_HEADERS))","2.6.10")
VERSION:=2
PATCHLEVEL:=6
SUBLEVEL:=10
LINUX_HEADERS_SITE:=http://ep09.pld-linux.org/~mmazur/linux-libc-headers/
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.6.10.0.tar.bz2
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.6.10.0
endif

ifeq ("$(strip $(DEFAULT_KERNEL_HEADERS))","2.6.11")
VERSION:=2
PATCHLEVEL:=6
SUBLEVEL:=11
LINUX_HEADERS_SITE:=http://ep09.pld-linux.org/~mmazur/linux-libc-headers/
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.6.11.0.tar.bz2
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.6.11.0
endif

ifeq ("$(strip $(DEFAULT_KERNEL_HEADERS))","2.6.12")
VERSION:=2
PATCHLEVEL:=6
SUBLEVEL:=12
LINUX_HEADERS_SITE:=http://ep09.pld-linux.org/~mmazur/linux-libc-headers/
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.6.12.0.tar.bz2
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.6.12.0
endif

LINUX_HEADERS_VERSION:=$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)

LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux

$(DL_DIR)/$(LINUX_HEADERS_SOURCE):
	mkdir -p $(DL_DIR)
	$(WGET) -P $(DL_DIR) $(LINUX_HEADERS_SITE)/$(LINUX_HEADERS_SOURCE)

$(LINUX_HEADERS_DIR)/.unpacked: $(DL_DIR)/$(LINUX_HEADERS_SOURCE)
	rm -rf $(LINUX_HEADERS_DIR)
	mkdir -p $(TOOL_BUILD_DIR)
	bzcat $(DL_DIR)/$(LINUX_HEADERS_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
ifneq ($(LINUX_HEADERS_UNPACK_DIR),$(LINUX_HEADERS_DIR))
	mv $(LINUX_HEADERS_UNPACK_DIR) $(LINUX_HEADERS_DIR)
endif
	touch $(LINUX_HEADERS_DIR)/.unpacked

$(LINUX_HEADERS_DIR)/.patched: $(LINUX_HEADERS_DIR)/.unpacked
	toolchain/patch-kernel.sh $(LINUX_HEADERS_DIR) toolchain/kernel-headers linux-libc-headers-$(LINUX_HEADERS_VERSION)\*.patch
ifeq ($(strip $(ARCH)),nios2)
	toolchain/patch-kernel.sh $(LINUX_HEADERS_DIR) toolchain/kernel-headers linux-libc-headers-$(LINUX_HEADERS_VERSION)-nios2nommu.patch.conditional
endif
	touch $(LINUX_HEADERS_DIR)/.patched

$(LINUX_HEADERS_DIR)/.configured: $(LINUX_HEADERS_DIR)/.patched
	rm -f $(LINUX_HEADERS_DIR)/include/asm
	@if [ ! -f $(LINUX_HEADERS_DIR)/Makefile ] ; then \
	    echo -e "VERSION = $(VERSION)\nPATCHLEVEL = $(PATCHLEVEL)\n" > \
		    $(LINUX_HEADERS_DIR)/Makefile; \
	    echo -e "SUBLEVEL = $(SUBLEVEL)\nEXTRAVERSION =\n" >> \
		    $(LINUX_HEADERS_DIR)/Makefile; \
	    echo -e "KERNELRELEASE=\$$(VERSION).\$$(PATCHLEVEL).\$$(SUBLEVEL)\$$(EXTRAVERSION)" >> \
		    $(LINUX_HEADERS_DIR)/Makefile; \
	fi;
	@if [ "$(ARCH)" = "powerpc" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-ppc$(NOMMU) asm;) \
	elif [ "$(ARCH)" = "mips" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-mips$(NOMMU) asm;) \
	elif [ "$(ARCH)" = "mipsel" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-mips$(NOMMU) asm;) \
	elif [ "$(ARCH)" = "nios2" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-nios2nommu asm;) \
	elif [ "$(ARCH)" = "arm" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-arm$(NOMMU) asm; \
	     cd asm; \
	     if [ ! -L proc ] ; then \
	     ln -fs proc-armv proc; \
	     ln -fs arch-ebsa285 arch; fi); \
	elif [ "$(ARCH)" = "armeb" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-arm$(NOMMU) asm; \
	     cd asm; \
	     if [ ! -L proc ] ; then \
	     ln -fs proc-armv proc; \
	     ln -fs arch-ebsa285 arch; fi); \
	elif [ "$(ARCH)" = "cris" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-cris asm;) \
	elif [ "$(ARCH)" = "sh3" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-sh asm; \
	     cd asm; \
	     ln -s cpu-sh3 cpu) \
	elif [ "$(ARCH)" = "sh3eb" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-sh asm; \
	     cd asm; \
	     ln -s cpu-sh3 cpu) \
	elif [ "$(ARCH)" = "sh4" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-sh asm; \
	     cd asm; \
	     ln -s cpu-sh4 cpu) \
	elif [ "$(ARCH)" = "sh4eb" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-sh asm; \
	     cd asm; \
	     ln -s cpu-sh4 cpu) \
	elif [ "$(ARCH)" = "i386" -o "$(ARCH)" = "i486" -o "$(ARCH)" = "i586" -o "$(ARCH)" = "i686" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-i386$(NOMMU) asm;) \
	else \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-$(ARCH)$(NOMMU) asm;) \
	fi
	touch $(LINUX_HEADERS_DIR)/include/linux/autoconf.h;
	touch $(LINUX_HEADERS_DIR)/.configured

$(LINUX_KERNEL): $(LINUX_HEADERS_DIR)/.configured

kernel-headers: $(LINUX_HEADERS_DIR)/.configured

kernel-headers-source: $(DL_DIR)/$(LINUX_HEADERS_SOURCE)

kernel-headers-clean: clean
	rm -f $(LINUX_KERNEL)
	rm -rf $(LINUX_HEADERS_DIR)

kernel-headers-dirclean:
	rm -rf $(LINUX_HEADERS_DIR)

