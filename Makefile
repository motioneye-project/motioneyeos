# Makefile for a simple busybox/uClibc root filesystem
#
# Copyright (C) 2001-2003 Erik Andersen <andersen@codepoet.org>
# Copyright (C) 2002 by Tim Riker <Tim@Rikers.org>
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


TARGETS=
#############################################################
#
# EDIT this stuff to suit your system and preferences
#
# Use := when possible to get precomputation, thereby 
# speeding up the build process.
#
#############################################################

# What sortof target system shall we compile this for?
ARCH:=i386
#ARCH:=arm
#ARCH:=powerpc
#ARCH:=whatever

# enable to build a native gcc toolchain with uclibc support
USE_UCLIBC_TOOLCHAIN:=true

# If you are building a native gcc toolchain, do you want to
# build the old gcc-2.95 based toolchain, or would you prefer
# a nice and shiny new gcc-3.2.1 toolchain?
GCC_2_95_TOOLCHAIN:=false

# Enable this to use the uClibc daily snapshot instead of a released
# version.  Daily snapshots may contain new features and bugfixes. Or
# they may not even compile at all, depending on what Erik is doing...
USE_UCLIBC_SNAPSHOT:=true

# Enable this to use the busybox daily snapshot instead of a released
# version.  Daily snapshots may contain new features and bugfixes. Or
# they may not even compile at all....
USE_BUSYBOX_SNAPSHOT:=false

# Enable large file (files > 2 GB) support
BUILD_WITH_LARGEFILE:=true

# Command used to download source code
WGET:=wget --passive-ftp

# Optimize toolchain for which type of CPU?
OPTIMIZE_FOR_CPU=$(ARCH)
#OPTIMIZE_FOR_CPU=i486
#OPTIMIZE_FOR_CPU=strongarm
#OPTIMIZE_FOR_CPU=whatever

# Any additional gcc options you may want to include....
EXTRA_GCC_CONFIG_OPTIONS=
#EXTRA_GCC_CONFIG_OPTIONS=--without-float

#############################################################
#
# The list of stuff to build for the target filesystem
#
#############################################################
# The toolchain comes next if we are building one
ifeq ($(USE_UCLIBC_TOOLCHAIN),true)
TARGETS+=uclibc_toolchain
endif

# Do you want user mode Linux (x86 only), or are you building a 
# real kernel # that will run on its own?  Perhaps you have a 
# kernel you have already configured and you want to use that?
#TARGETS+=linux
TARGETS+=user-mode-linux
#TARGETS+=system-linux

# The default minimal set
TARGETS+=busybox tinylogin

# Openssh...
#TARGETS+=zlib openssl openssh

# Everything needed to build a full uClibc development system!
#TARGETS+=coreutils findutils bash make diffutils patch sed
#TARGETS+=ed flex bison file gawk tar grep gcc_target

# Of course, if you are installing a development system, you
# may want some header files so you can compile stuff....
#TARGETS+=ncurses-headers zlib-headers openssl-headers

# More development system stuff for those that want it
#TARGETS+=m4 autoconf automake libtool

# Some nice debugging tools
#TARGETS+=gdb strace

# The Valgrind debugger (x86 only)
#TARGETS+=valgrind

# Some stuff for access points and firewalls
#TARGETS+=iptables hostap wtools dhcp_relay bridge

# Run customize.mk at the very end to add your own special config.
# This is useful for making your own distro within the buildroot
# process.
# TARGETS+=customize

#############################################################
#
# Pick your root filesystem type.
#
#############################################################
TARGETS+=ext2root

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
HOSTCC:=gcc
BASE_DIR:=${shell pwd}
SOURCE_DIR:=$(BASE_DIR)/sources
DL_DIR:=$(SOURCE_DIR)/dl
PATCH_DIR=$(SOURCE_DIR)/patches
BUILD_DIR:=$(BASE_DIR)/build
TARGET_DIR:=$(BUILD_DIR)/root
STAGING_DIR=$(BUILD_DIR)/staging_dir
TOOL_BUILD_DIR=$(BASE_DIR)/build
TARGET_PATH=$(STAGING_DIR)/bin:/bin:/sbin:/usr/bin:/usr/sbin
TARGET_CROSS=$(STAGING_DIR)/bin/$(ARCH)-uclibc-
TARGET_CC=$(TARGET_CROSS)gcc
STRIP=$(TARGET_CROSS)strip --remove-section=.comment --remove-section=.note
#STRIP:=/bin/true
IMAGE:=$(BASE_DIR)/root_fs
GNU_TARGET_NAME=$(OPTIMIZE_FOR_CPU)-linux
KERNEL_CROSS=$(STAGING_DIR)/bin/$(ARCH)-uclibc-

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

$(STAGING_DIR):
	rm -rf $(STAGING_DIR)
	mkdir -p $(STAGING_DIR)/lib
	mkdir -p $(STAGING_DIR)/usr/lib
	mkdir -p $(STAGING_DIR)/include

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
	rm -rf $(TARGET_DIR) $(STAGING_DIR) $(IMAGE)

dirclean: $(TARGETS_DIRCLEAN)
	rm -rf $(TARGET_DIR) $(STAGING_DIR) $(IMAGE)

distclean:
	rm -rf $(DL_DIR) $(BUILD_DIR) $(LINUX_KERNEL) $(IMAGE)

sourceball: 
	rm -rf $(BUILD_DIR)
	set -e; \
	cd ..; \
	rm -f buildroot.tar.bz2; \
	tar -cvf buildroot.tar buildroot; \
	bzip2 -9 buildroot.tar; \
