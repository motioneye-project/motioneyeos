# Makefile for to build a gcc/uClibc toolchain linked vs uClibc
#
# Copyright (C) 2002 Erik Andersen <andersen@uclibc.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

#############################################################
#
# You should probably leave this stuff alone unless you are
# hacking on the toolchain...
#
#############################################################
GNU_TARGET_NAME:=$(ARCH)-linux
MAKE:=make

#############################################################
#
# Where we can find things....
#
# for various dependancy reasons, these need to live
# here at the top...  Easier to find things here anyways...
#
#############################################################
BINUTILS_DIR2:=$(BUILD_DIR)/binutils-target
GCC_BUILD_DIR3:=$(BUILD_DIR)/gcc-target


#############################################################
#
# build binutils
#
#############################################################
$(BINUTILS_DIR2)/.configured:
	mkdir -p $(BINUTILS_DIR2)
	mkdir -p $(TARGET_DIR)/usr/include
	mkdir -p $(TARGET_DIR)/usr/$(GNU_TARGET_NAME)/
	#(cd $(TARGET_DIR)/usr/$(GNU_TARGET_NAME); ln -fs ../lib)
	#(cd $(TARGET_DIR)/usr/$(GNU_TARGET_NAME); ln -fs ../include)
	(cd $(TARGET_DIR)/usr/$(GNU_TARGET_NAME); ln -fs ../include sys-include)
	(cd $(BINUTILS_DIR2); PATH=$$PATH:$(STAGING_DIR)/bin CC=$(TARGET_CROSS)gcc \
		$(BINUTILS_DIR)/configure --enable-shared \
		--target=$(GNU_TARGET_NAME) --prefix=/usr \
		--enable-targets=$(GNU_TARGET_NAME) \
		--program-prefix="");
	touch $(BINUTILS_DIR2)/.configured

$(BINUTILS_DIR2)/binutils/objdump: $(BINUTILS_DIR2)/.configured
	$(MAKE) tooldir=$(TARGET_DIR) -C $(BINUTILS_DIR2);

$(TARGET_DIR)/$(GNU_TARGET_NAME)/bin/ld: $(BINUTILS_DIR2)/binutils/objdump 
	$(MAKE) DESTDIR=$(TARGET_DIR) prefix=$(TARGET_DIR)/usr \
		bindir=$(TARGET_DIR)/usr/bin -C $(BINUTILS_DIR2) install
	rm -rf $(TARGET_DIR)/usr/info $(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share

$(TARGET_DIR)/usr/lib/libg.a:
	$(STAGING_DIR)/$(GNU_TARGET_NAME)/bin/ar rv $(TARGET_DIR)/usr/lib/libg.a;

binutils_target: gcc_final $(TARGET_DIR)/$(GNU_TARGET_NAME)/bin/ld $(TARGET_DIR)/usr/lib/libg.a

binutils_target-clean:
	rm -f $(TARGET_DIR)/bin/$(GNU_TARGET_NAME)*
	-$(MAKE) -C $(BINUTILS_DIR2) clean

binutils_target-dirclean:
	rm -rf $(BINUTILS_DIR2)




#############################################################
#
# uClibc just needs its header files and whatnot installed.
#
#############################################################

$(TARGET_DIR)/lib/libc.a: $(STAGING_DIR)/lib/libc.a
	$(MAKE) DEVEL_PREFIX=$(TARGET_DIR)/usr SYSTEM_DEVEL_PREFIX=$(TARGET_DIR) \
		DEVEL_TOOL_PREFIX=$(TARGET_DIR) -C $(UCLIBC_DIR) \
		install_dev
	rm -rf $(TARGET_DIR)/include

uclibc_target: gcc_final $(TARGET_DIR)/lib/libc.a

uclibc_target-clean:
	rm -f $(TARGET_DIR)/include

uclibc_target-dirclean:
	rm -f $(TARGET_DIR)/include



#############################################################
#
# Next build target gcc compiler
#
#############################################################
$(GCC_BUILD_DIR3)/.configured:
	mkdir -p $(GCC_BUILD_DIR3)
	(cd $(GCC_BUILD_DIR3); PATH=$$PATH:$(STAGING_DIR)/bin AR=$(TARGET_CROSS)ar \
		RANLIB=$(TARGET_CROSS)ranlib LD=$(TARGET_CROSS)ld CC=$(TARGET_CROSS)gcc \
		$(GCC_DIR)/configure \
		--host=$(GNU_TARGET_NAME) --target=$(GNU_TARGET_NAME) --prefix=/usr \
		--with-local-prefix=$(STAGING_DIR)/usr \
		--enable-target-optspace --disable-nls --with-gnu-ld \
		--enable-shared --enable-languages=c,c++ );
	perl -i -p -e "s,ac_cv_prog_cc_cross=no,ac_cv_prog_cc_cross=yes,g;" $(GCC_BUILD_DIR3)/config.cache
	perl -i -p -e "s,^build_tooldir=no,ac_cv_prog_cc_cross=yes,g;" $(GCC_BUILD_DIR3)/config.cache
	touch $(GCC_BUILD_DIR3)/.configured

$(GCC_BUILD_DIR3)/.compiled: $(GCC_BUILD_DIR3)/.configured
	PATH=$$PATH:$(STAGING_DIR)/bin $(MAKE) -C $(GCC_BUILD_DIR3)
	touch $(GCC_BUILD_DIR3)/.compiled

$(GCC_BUILD_DIR3)/.installed: $(GCC_BUILD_DIR3)/.compiled
	PATH=$$PATH:$(STAGING_DIR)/bin $(MAKE) DESTDIR=$(TARGET_DIR) prefix=$(TARGET_DIR)/usr \
		-C $(GCC_BUILD_DIR3) install;
	touch $(GCC_BUILD_DIR3)/.installed

$(GCC_BUILD_DIR3)/.stripped: $(GCC_BUILD_DIR3)/.installed
	-strip --strip-all -R .note -R .comment $(TARGET_DIR)/bin/* 
	touch $(BUILD_DIR)/.stripped

gcc_target: uclibc_target binutils_target $(GCC_BUILD_DIR3)/.stripped

gcc_target-clean:
	rm -rf $(GCC_BUILD_DIR3)
	rm -f $(TARGET_DIR)/bin/$(GNU_TARGET_NAME)*

gcc_target-dirclean:
	rm -rf $(GCC_BUILD_DIR3)

