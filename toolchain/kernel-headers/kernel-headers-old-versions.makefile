#############################################################
#
# Setup the kernel headers. I include a generic package of
# kernel headers here, so you shouldn't need to include your
# own. Be aware these kernel headers _will_ get blown away
# by a 'make clean' so don't put anything sacred in here...
#
#############################################################
ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.4.25")
VERSION:=2
PATCHLEVEL:=4
SUBLEVEL:=25
LINUX_HEADERS_VERSION:=$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
LINUX_HEADERS_SITE:=http://www.uclibc.org/downloads/toolchain
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.4.25.tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.4.25
endif

ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.4.27")
VERSION:=2
PATCHLEVEL:=4
SUBLEVEL:=27
LINUX_HEADERS_VERSION:=$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
LINUX_HEADERS_SITE:=http://www.uclibc.org/downloads/toolchain
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.4.27.tar.bz2
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.4.27
endif

ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.4.29")
VERSION:=2
PATCHLEVEL:=4
SUBLEVEL:=29
LINUX_HEADERS_VERSION:=$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
LINUX_HEADERS_SITE:=http://www.uclibc.org/downloads/toolchain
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.4.29.tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.4.29
endif

ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.4.31")
VERSION:=2
PATCHLEVEL:=4
SUBLEVEL:=31
LINUX_HEADERS_VERSION:=$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
LINUX_HEADERS_SITE:=http://www.uclibc.org/downloads/toolchain
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.4.31.tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.4.31
endif

ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.6.9")
VERSION:=2
PATCHLEVEL:=6
SUBLEVEL:=9
LINUX_HEADERS_VERSION:=$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
LINUX_HEADERS_SITE:=http://ep09.pld-linux.org/~mmazur/linux-libc-headers/
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.6.9.1.tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.6.9.1
endif

ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.6.10")
VERSION:=2
PATCHLEVEL:=6
SUBLEVEL:=10
LINUX_HEADERS_VERSION:=$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
LINUX_HEADERS_SITE:=http://ep09.pld-linux.org/~mmazur/linux-libc-headers/
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.6.10.0.tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.6.10.0
endif

ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.6.11")
VERSION:=2
PATCHLEVEL:=6
SUBLEVEL:=11
LINUX_HEADERS_VERSION:=$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
LINUX_HEADERS_SITE:=http://ep09.pld-linux.org/~mmazur/linux-libc-headers/
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.6.11.0.tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.6.11.0
endif

ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.6.12")
VERSION:=2
PATCHLEVEL:=6
SUBLEVEL:=12
LINUX_HEADERS_VERSION:=$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
LINUX_HEADERS_SITE:=http://ep09.pld-linux.org/~mmazur/linux-libc-headers/
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.6.12.0.tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.6.12.0
endif
