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
else
UCLIBC_DIR:=$(BUILD_DIR)/uClibc-0.9.12
UCLIBC_SOURCE:=uClibc-0.9.12.tar.bz2
endif
#UCLIBC_PATCH=$(SOURCE_DIR)/uClibc.patch
UCLIBC_URI:=ftp://www.uclibc.org/uClibc
ifeq ($(strip $(BUILD_WITH_LARGEFILE)),true)
LARGEFILE=true
else
LARGEFILE=false
endif
ifneq ($(CROSS),)
CROSSARG:=--cross="$(CROSS)"
endif

$(DL_DIR)/$(UCLIBC_SOURCE):
	wget -P $(DL_DIR) --passive-ftp $(UCLIBC_URI)/$(UCLIBC_SOURCE)

uclibc-source: $(DL_DIR)/$(UCLIBC_SOURCE) #$(UCLIBC_PATCH)

$(UCLIBC_DIR)/.unpacked: $(DL_DIR)/$(UCLIBC_SOURCE) #$(UCLIBC_PATCH)
	bzcat $(DL_DIR)/$(UCLIBC_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(UCLIBC_DIR)/.unpacked

ifeq ($(LINUX_DIR),)
LINUX_DIR:=$(BUILD_DIR)/linux
endif

$(UCLIBC_DIR)/Config: $(UCLIBC_DIR)/.unpacked
	cp $(UCLIBC_DIR)/extra/Configs/Config.$(ARCH) $(UCLIBC_DIR)/Config~;
	echo "TARGET_ARCH=$(ARCH)" >> $(UCLIBC_DIR)/Config~
	$(UCLIBC_DIR)/extra/Configs/uClibc_config_fix.pl \
		--arch=$(ARCH) \
		$(CROSSARG) --c99_math=true \
		--devel_prefix=$(STAGING_DIR) \
		--kernel_dir=$(LINUX_DIR) \
		--float=true \
		--c99_math=true \
		--long_long=true \
		--float=true \
		--shadow=true \
		--threads=true \
		--rpc_support=true \
		--large_file=true \
		--mmu=true \
		--debug=false \
		--ldso_path="/lib" \
		--shared_support=true \
		--file=$(UCLIBC_DIR)/Config~ \
		> $(UCLIBC_DIR)/Config; 
	perl -i -p -e 's,^SYSTEM_DEVEL_PREFIX.*,SYSTEM_DEVEL_PREFIX=$(STAGING_DIR),g' \
		$(UCLIBC_DIR)/Config
	perl -i -p -e 's,^DEVEL_TOOL_PREFIX.*,DEVEL_TOOL_PREFIX=$(STAGING_DIR)/usr,g' \
		$(UCLIBC_DIR)/Config
	perl -i -p -e 's,^HAS_WCHAR.*,HAS_WCHAR=true,g' $(UCLIBC_DIR)/Config

$(UCLIBC_DIR)/lib/libc.a: $(UCLIBC_DIR)/Config
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

uclibc: $(LINUX_KERNEL) $(STAGING_DIR)/lib/libc.a $(TARGET_DIR)/lib/libc.so.0 $(TARGET_DIR)/usr/bin/ldd

uclibc-clean:
	rm -f $(TARGET_DIR)/lib/libc.so.0
	-make -C $(UCLIBC_DIR) clean
	rm -f $(UCLIBC_DIR)/Config

uclibc-dirclean:
	rm -rf $(UCLIBC_DIR)

endif
