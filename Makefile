# Makefile for a simple busybox/uClibc root filesystem
#
# Copyright (C) 2001-2004 Erik Andersen <andersen@codepoet.org>
# Copyright (C) 2002 by Tim Riker <Tim@Rikers.org>
# Copyright (C) 2004 Manuel Novoa III <mjn3@uclibc.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Library General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Library General Public License for more details.
#
# You should have received a copy of the GNU Library General Public
# License along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
# USA


#############################################################
#
# EDIT this stuff to suit your system and preferences
#
# Use := when possible to get precomputation, thereby
# speeding up the build process.
#
#############################################################

# What sort of target system shall we compile this for?
#
ARCH:=i386
#ARCH:=arm
#ARCH:=armeb
#ARCH:=mips
#ARCH:=mipsel
#ARCH:=powerpc
#ARCH:=sh4
#ARCH:=cris
#ARCH:=sh64
#ARCH:=m68k
#ARCH:=v850
#ARCH:=sparc
#ARCH:=whatever

# Choose the kernel headers to use for kernel-headers target. This is
# ignored if you are building your own kernel or using the system kernel.
#
#DEFAULT_KERNEL_HEADERS:=2.4.25
DEFAULT_KERNEL_HEADERS:=2.4.27
#DEFAULT_KERNEL_HEADERS:=2.6.7
#DEFAULT_KERNEL_HEADERS:=2.6.8

# Choose gcc version.
# WARNING -- 2.95 currently only builds for i386, arm, mips*, and powerpc.
# WARNING -- 2.95 does not currently build natively for the target.
#
#GCC_VERSION:=2.95
#GCC_VERSION:=3.3.3
#GCC_VERSION:=3.3.4
#GCC_VERSION:=3.4.0
#GCC_VERSION:=3.4.1
GCC_VERSION:=3.4.2

# Choose binutils version.
#
#BINUTILS_VERSION:=2.14.90.0.6
#BINUTILS_VERSION:=2.14.90.0.7
#BINUTILS_VERSION:=2.14.90.0.8
#BINUTILS_VERSION:=2.15
#BINUTILS_VERSION:=2.15.90.0.1
#BINUTILS_VERSION:=2.15.90.0.1.1
#BINUTILS_VERSION:=2.15.90.0.2
#BINUTILS_VERSION:=2.15.90.0.3
#BINUTILS_VERSION:=2.15.91.0.1
BINUTILS_VERSION:=2.15.91.0.2
#BINUTILS_VERSION:=2.15.92.0.2

# Choose gdb version.
#
#GDB_VERSION:=5.3
GDB_VERSION:=6.1.1
#GDB_VERSION:=6.2
#GDB_VERSION:=6.2.1


# Enable this to use the uClibc daily snapshot instead of a released
# version.  Daily snapshots may contain new features and bugfixes. Or
# they may not even compile at all, depending on what Erik is doing.

# Do you wish to use the latest release (), latest snapshot (snapshot),
# or the snapshot from a specific date (yyyymmdd)?  Note that snapshots
# may contain new features and bugfixes.  Or they may not even compile
# at all, depending on what Erik and Manuel are doing.
#
#USE_UCLIBC_SNAPSHOT:=
USE_UCLIBC_SNAPSHOT:=snapshot
#USE_UCLIBC_SNAPSHOT:=20040807

# Do you wish to use the latest release (), latest snapshot (snapshot),
# or the snapshot from a specific date (yyyymmdd)?  Note that snapshots
# may contain new features and bugfixes.  Or they may not even compile
# at all...
#
#USE_BUSYBOX_SNAPSHOT:=
USE_BUSYBOX_SNAPSHOT:=snapshot
#USE_BUSYBOX_SNAPSHOT:=20040807

# Enable large file (files > 2 GB) support
BUILD_WITH_LARGEFILE:=true

# Command used to download source code
WGET:=wget --passive-ftp

# Optimize toolchain for which type of CPU?
OPTIMIZE_FOR_CPU=$(ARCH)
#OPTIMIZE_FOR_CPU=i686
# Note... gcc 2.95 does not seem to like anything higher than i586.
#OPTIMIZE_FOR_CPU=i586
#OPTIMIZE_FOR_CPU=whatever

# Might be worth experimenting with for gcc 3.4.x.
GCC_WITH_CPU:=
GCC_WITH_ARCH:=
GCC_WITH_TUNE:=

#GCC_WITH_CPU:=--with-cpu=
#GCC_WITH_ARCH:=--with-arch=
#GCC_WITH_TUNE:=--with-tune=

# Soft floating point options.
# Notes:
#   Builds for gcc 3.4.x.
#   Can build for gcc 3.3.x for mips, mipsel, powerpc, and arm (special)
#      by using custom specs files (currently for 3.3.4 only).
#   NOTE!!! The libfloat stuff is currently removed from uClibc.  The
#      arm soft float for 3.3.x will require reenabling it.
#   (i386 support will be added back in at some point.)
#   Only tested with multilib enabled.
#   For i386, long double is the same as double (64 bits).  While this
#      is unusual for x86, it seemed the best approach considering the
#      limitations in the gcc floating point emulation library.
#   For arm, soft float uses the usual libfloat routines.
# (Un)comment the appropriate line below.
#SOFT_FLOAT:=true
SOFT_FLOAT:=false

TARGET_OPTIMIZATION=-Os
TARGET_DEBUGGING= #-g

# Currently the unwind stuff seems to work for staticly linked apps but
# not dynamic.  So use setjmp/longjmp exceptions by default.
GCC_USE_SJLJ_EXCEPTIONS:=--enable-sjlj-exceptions
#GCC_USE_SJLJ_EXCEPTIONS:=

# Any additional gcc options you may want to include....
EXTRA_GCC_CONFIG_OPTIONS:=

# Enable the following if you want locale/gettext/i18n support.
# NOTE!  Currently the pregnerated locale stuff only works for x86!
#ENABLE_LOCALE:=true
ENABLE_LOCALE:=false

# If you want multilib enabled, enable this...
MULTILIB:=--enable-multilib

# Build/install c++ compiler and libstdc++?
INSTALL_LIBSTDCPP:=true

# Build/install java compiler and libgcj? (requires c++)
# WARNING!!! DOES NOT BUILD FOR TARGET WITHOUT INTERVENTION!!!  mjn3
#INSTALL_LIBGCJ:=true
INSTALL_LIBGCJ:=false

# For SMP machines some stuff can be run in parallel
#JLEVEL=-j3

#############################################################
#
# The list of stuff to build for the target filesystem
#
#############################################################
TARGETS:=host-sed

TARGETS+=uclibc-configured binutils gcc ccache

# Are you building your own kernel?  Perhaps you have a kernel
# you have already configured and you want to use that?  The
# default is to just use a set of known working kernel headers.
# Unless you want to build a kernel, I recommend just using
# that...
TARGETS+=kernel-headers
#TARGETS+=linux

# The default minimal set
TARGETS+=busybox #tinylogin

# Openssh...
#TARGETS+=zlib openssl openssh
# Dropbear sshd is much smaller than openssl + openssh
#TARGETS+=dropbear_sshd

# Everything needed to build a full uClibc development system!
#TARGETS+=coreutils findutils bash make diffutils patch sed
#TARGETS+=ed flex bison file gawk tar grep bzip2

#If you want a development system, you probably want gcc built
# with uClibc so it can run within your dev system...
#TARGETS+=gcc_target ccache_target

# Of course, if you are installing a development system, you
# may want some header files so you can compile stuff....
#TARGETS+=ncurses-headers zlib-headers openssl-headers

# More development system stuff for those that want it
#TARGETS+=m4 autoconf automake libtool

# Some nice debugging tools for the host
#TARGETS+=gdbclient
# Some nice debugging tools for the target
#TARGETS+=gdbserver gdb_target
#TARGETS+=strace ltrace

# The Valgrind debugger (x86 only)
#TARGETS+=valgrind

# Some stuff for access points and firewalls
#TARGETS+=iptables hostap wtools dhcp_relay bridge
#TARGETS+=iproute2 netsnmp

# Run customize.mk at the very end to add your own special config.
# This is useful for making your own distro within the buildroot
# process.
# TARGETS+=customize

#############################################################
#
# Pick your root filesystem type.
#
#############################################################
#TARGETS+=ext2root

# Must mount cramfs with 'ramdisk_blocksize=4096'
#TARGETS+=cramfsroot

# You may need to edit make/jffs2root.mk to change target
# endian-ness or similar, but this is sufficient for most
# things as-is...
#TARGETS+=jffs2root

#############################################################
#
# You should probably leave this stuff alone unless you know
# what you are doing.
#
#############################################################

ifeq ($(SOFT_FLOAT),true)
# gcc 3.4.x soft float configuration is different than previous versions.
ifeq ($(findstring 3.4.,$(GCC_VERSION)),3.4.)
SOFT_FLOAT_CONFIG_OPTION:=--with-float=soft
else
SOFT_FLOAT_CONFIG_OPTION:=--without-float
endif
TARGET_SOFT_FLOAT:=-msoft-float
ARCH_FPU_SUFFIX:=_nofpu
else
SOFT_FLOAT_CONFIG_OPTION:=
TARGET_SOFT_FLOAT:=
ARCH_FPU_SUFFIX:=
endif

ifeq ($(INSTALL_LIBGCJ),true)
INSTALL_LIBSTDCPP:=true
endif

# WARNING -- uClibc currently disables large file support on cris.
ifeq ("$(strip $(ARCH))","cris")
BUILD_WITH_LARGEFILE:=false
endif

ifneq ($(BUILD_WITH_LARGEFILE),true)
DISABLE_LARGEFILE= --disable-largefile
endif
TARGET_CFLAGS=$(TARGET_OPTIMIZATION) $(TARGET_DEBUGGING)

HOSTCC:=gcc
BASE_DIR:=${shell pwd}
SOURCE_DIR:=$(BASE_DIR)/sources
DL_DIR:=$(SOURCE_DIR)/dl
PATCH_DIR=$(SOURCE_DIR)/patches
BUILD_DIR:=$(BASE_DIR)/build_$(ARCH)$(ARCH_FPU_SUFFIX)
TARGET_DIR:=$(BUILD_DIR)/root
STAGING_DIR=$(BUILD_DIR)/staging_dir
TOOL_BUILD_DIR=$(BASE_DIR)/toolchain_build_$(ARCH)$(ARCH_FPU_SUFFIX)
TARGET_PATH=$(STAGING_DIR)/bin:/bin:/sbin:/usr/bin:/usr/sbin
IMAGE:=$(BASE_DIR)/root_fs_$(ARCH)$(ARCH_FPU_SUFFIX)
REAL_GNU_TARGET_NAME=$(OPTIMIZE_FOR_CPU)-linux-uclibc
GNU_TARGET_NAME=$(OPTIMIZE_FOR_CPU)-linux
KERNEL_CROSS=$(STAGING_DIR)/bin/$(OPTIMIZE_FOR_CPU)-linux-uclibc-
TARGET_CROSS=$(STAGING_DIR)/bin/$(OPTIMIZE_FOR_CPU)-linux-uclibc-
TARGET_CC=$(TARGET_CROSS)gcc
STRIP=$(TARGET_CROSS)strip --remove-section=.comment --remove-section=.note


HOST_ARCH:=$(shell $(HOSTCC) -dumpmachine | sed -e s'/-.*//' \
	-e 's/sparc.*/sparc/' \
	-e 's/arm.*/arm/g' \
	-e 's/m68k.*/m68k/' \
	-e 's/ppc/powerpc/g' \
	-e 's/v850.*/v850/g' \
	-e 's/sh[234]/sh/' \
	-e 's/mips-.*/mips/' \
	-e 's/mipsel-.*/mipsel/' \
	-e 's/cris.*/cris/' \
	-e 's/i[3-9]86/i386/' \
	)
GNU_HOST_NAME:=$(HOST_ARCH)-pc-linux-gnu
TARGET_CONFIGURE_OPTS=PATH=$(TARGET_PATH) \
		AR=$(TARGET_CROSS)ar \
		AS=$(TARGET_CROSS)as \
		LD=$(TARGET_CROSS)ld \
		NM=$(TARGET_CROSS)nm \
		CC=$(TARGET_CROSS)gcc \
		GCC=$(TARGET_CROSS)gcc \
		CXX=$(TARGET_CROSS)g++ \
		RANLIB=$(TARGET_CROSS)ranlib

ifeq ($(ENABLE_LOCALE),true)
DISABLE_NLS:=
else
DISABLE_NLS:=--disable-nls
endif


all:   world

TARGETS_CLEAN:=$(patsubst %,%-clean,$(TARGETS))
TARGETS_SOURCE:=$(patsubst %,%-source,$(TARGETS))
TARGETS_DIRCLEAN:=$(patsubst %,%-dirclean,$(TARGETS))

world: $(DL_DIR) $(BUILD_DIR) $(STAGING_DIR) $(TARGET_DIR) $(TARGETS)

.PHONY: all world clean dirclean distclean source $(TARGETS) \
	$(TARGETS_CLEAN) $(TARGETS_DIRCLEAN) $(TARGETS_SOURCE)

include make/*.mk

#############################################################
#
# staging and target directories do NOT list these as
# dependancies anywhere else
#
#############################################################
$(DL_DIR):
	mkdir $(DL_DIR)

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

$(TOOL_BUILD_DIR):
	mkdir $(TOOL_BUILD_DIR)

$(STAGING_DIR):
	rm -rf $(STAGING_DIR)
	mkdir -p $(STAGING_DIR)/lib
	mkdir -p $(STAGING_DIR)/include
	mkdir -p $(STAGING_DIR)/$(REAL_GNU_TARGET_NAME)
	ln -sf ../lib $(STAGING_DIR)/$(REAL_GNU_TARGET_NAME)/lib

$(TARGET_DIR):
	rm -rf $(TARGET_DIR)
	zcat $(SOURCE_DIR)/skel.tar.gz | tar -C $(BUILD_DIR) -xf -
	cp -a $(SOURCE_DIR)/target_skeleton/* $(TARGET_DIR)/
	-find $(TARGET_DIR) -type d -name CVS -exec rm -rf {} \; > /dev/null 2>&1

source: $(TARGETS_SOURCE)

#############################################################
#
# Cleanup and misc junk
#
#############################################################
clean: $(TARGETS_CLEAN)
	rm -rf $(STAGING_DIR) $(TARGET_DIR) $(IMAGE)

dirclean: $(TARGETS_DIRCLEAN)
	rm -rf $(STAGING_DIR) $(TARGET_DIR) $(IMAGE)

distclean:
	rm -rf $(DL_DIR) $(BUILD_DIR) $(LINUX_KERNEL) $(IMAGE)

sourceball:
	rm -rf $(BUILD_DIR)
	set -e; \
	cd ..; \
	rm -f buildroot.tar.bz2; \
	tar -cvf buildroot.tar buildroot; \
	bzip2 -9 buildroot.tar; \
