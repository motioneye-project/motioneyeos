#############################################################
#
# uClibc (the C library)
#
#############################################################
# Copyright (C) 2001, 2002 by Erik Andersen <andersen@codepoet.org>
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

ifeq ($(USE_UCLIBC_TOOLCHAIN),false)

ifeq ($(USE_UCLIBC_SNAPSHOT),true)
# Be aware that this changes daily....
UCLIBC_DIR=$(BUILD_DIR)/uClibc
UCLIBC_SOURCE=uClibc-snapshot.tar.bz2
UCLIBC_SITE:=http://www.uclibc.org/downloads/snapshots
else
UCLIBC_DIR:=$(BUILD_DIR)/uClibc-0.9.18
UCLIBC_SOURCE:=uClibc-0.9.18.tar.bz2
UCLIBC_SITE:=http://www.uclibc.org/downloads
endif
#UCLIBC_PATCH=$(SOURCE_DIR)/uClibc.patch
ifeq ($(strip $(BUILD_WITH_LARGEFILE)),true)
LARGEFILE=true
else
LARGEFILE=false
endif

$(DL_DIR)/$(UCLIBC_SOURCE):
	$(WGET) -P $(DL_DIR) $(UCLIBC_SITE)/$(UCLIBC_SOURCE)

uclibc-source: $(DL_DIR)/$(UCLIBC_SOURCE) #$(UCLIBC_PATCH)

$(UCLIBC_DIR)/.unpacked: $(DL_DIR)/$(UCLIBC_SOURCE) #$(UCLIBC_PATCH)
	bzcat $(DL_DIR)/$(UCLIBC_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(UCLIBC_DIR)/.unpacked

$(UCLIBC_DIR)/.configured: $(UCLIBC_DIR)/.unpacked
	perl -i -p -e 's,^CROSS=.*,TARGET_ARCH=$(ARCH)\nCC=$(HOSTCC),g' $(UCLIBC_DIR)/Rules.mak
	cp $(SOURCE_DIR)/uClibc.config $(UCLIBC_DIR)/.config
	perl -i -p -e 's,^KERNEL_SOURCE=.*,KERNEL_SOURCE=\"$(LINUX_DIR)\",g' $(UCLIBC_DIR)/.config
	perl -i -p -e 's,^DEVEL_PREFIX=.*,DEVEL_PREFIX=\"$(STAGING_DIR)\",g' $(UCLIBC_DIR)/.config
	perl -i -p -e 's,^SYSTEM_DEVEL_PREFIX=.*,SYSTEM_DEVEL_PREFIX=\"$(STAGING_DIR)\",g' $(UCLIBC_DIR)/.config
	perl -i -p -e 's,^DEVEL_TOOL_PREFIX=.*,DEVEL_TOOL_PREFIX=\"$(STAGING_DIR)/usr\",g' $(UCLIBC_DIR)/.config
	perl -i -p -e 's,^SHARED_LIB_LOADER_PATH=.*,SHARED_LIB_LOADER_PATH=\"/lib\",g' $(UCLIBC_DIR)/.config
	perl -i -p -e 's,^GCC_BIN=.*,GCC_BIN=$(STAGING_DIR)/bin/$(ARCH)-uclibc-gcc,g'  $(UCLIBC_DIR)/extra/gcc-uClibc/Makefile
	perl -i -p -e 's,^LD_BIN=.*,LD_BIN=$(STAGING_DIR)/bin/$(ARCH)-uclibc-ld,g'  $(UCLIBC_DIR)/extra/gcc-uClibc/Makefile     
	$(MAKE) -C $(UCLIBC_DIR) oldconfig
	touch $(UCLIBC_DIR)/.configured

$(UCLIBC_DIR)/lib/libc.a: $(UCLIBC_DIR)/.configured
	$(MAKE) -C $(UCLIBC_DIR)

$(STAGING_DIR)/lib/libc.a: $(UCLIBC_DIR)/lib/libc.a
	$(MAKE) -C $(UCLIBC_DIR) install_dev install_runtime install_toolchain

$(STAGING_DIR)/bin/$(ARCH)-uclibc-gcc: $(STAGING_DIR)/lib/libc.a
	$(MAKE) -C $(UCLIBC_DIR) install_toolchain

$(TARGET_DIR)/lib/libc.so.0: $(STAGING_DIR)/bin/$(ARCH)-uclibc-gcc
	$(MAKE) -C $(UCLIBC_DIR) DEVEL_PREFIX=$(TARGET_DIR) \
		SYSTEM_DEVEL_PREFIX=$(TARGET_DIR) \
		DEVEL_TOOL_PREFIX=$(TARGET_DIR)/usr \
		install_runtime

$(TARGET_DIR)/usr/bin/ldd: $(TARGET_DIR)/lib/libc.so.0
	$(MAKE) -C $(UCLIBC_DIR) PREFIX=$(TARGET_DIR) install_target_utils

uclibc: $(BUILD_DIR)/linux/.configured $(STAGING_DIR)/lib/libc.a \
	    $(TARGET_DIR)/lib/libc.so.0 $(TARGET_DIR)/usr/bin/ldd

uclibc-clean:
	rm -f $(TARGET_DIR)/lib/libc.so.0
	-$(MAKE) -C $(UCLIBC_DIR) clean
	rm -f $(UCLIBC_DIR)/.config

uclibc-dirclean:
	rm -rf $(UCLIBC_DIR)

endif
