# Makefile for to build a gcc/uClibc toolchain
#
# Copyright (C) 2002-2003 Erik Andersen <andersen@uclibc.org>
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

ifeq ($(USE_UCLIBC_TOOLCHAIN),true)
ifeq ($(GCC_2_95_TOOLCHAIN),true)

#############################################################
#
# You should probably leave this stuff alone unless you are
# hacking on the toolchain...
#
#############################################################
#Directory in which to build the toolchain
TOOL_BUILD_DIR=$(BASE_DIR)/toolchain_build_$(ARCH)

TARGET_LANGUAGES:=c,c++

# If you want multilib enabled, enable this...
MULTILIB:=--enable-multilib

#############################################################
#
# Where we can find things....
#
# for various dependancy reasons, these need to live
# here at the top...  Easier to find things here anyways...
#
#############################################################
BINUTILS_SITE:=http://ftp.kernel.org/pub/linux/devel/binutils
BINUTILS_SOURCE:=binutils-2.14.90.0.5.tar.bz2
BINUTILS_DIR:=$(TOOL_BUILD_DIR)/binutils-2.14.90.0.5
BINUTILS_CAT:=bzcat

ifeq ($(USE_UCLIBC_SNAPSHOT),true)
# Be aware that this changes daily....
UCLIBC_DIR=$(BUILD_DIR)/uClibc
UCLIBC_SOURCE=uClibc-snapshot.tar.bz2
UCLIBC_SITE:=http://www.uclibc.org/downloads/snapshots
else
UCLIBC_DIR:=$(BUILD_DIR)/uClibc-0.9.20
UCLIBC_SOURCE:=uClibc-0.9.20.tar.bz2
UCLIBC_SITE:=http://www.uclibc.org/downloads
endif

GCC_SITE:=http://www.uclibc.org/downloads/toolchain
GCC_SOURCE:=gcc-20011006.tar.bz2
GCC_DIR:=$(TOOL_BUILD_DIR)/gcc-20011006

STLPORT_SITE=http://www.stlport.org/archive
STLPORT_SOURCE=STLport-4.5.3.tar.gz
STLPORT_DIR=$(TOOL_BUILD_DIR)/STLport-4.5.3



#############################################################
#
# Setup some initial paths
#
#############################################################
$(STAGING_DIR)/.setup:
	mkdir -p $(TOOL_BUILD_DIR)
	mkdir -p $(DL_DIR)
	mkdir -p $(STAGING_DIR)
	mkdir -p $(STAGING_DIR)/include
	mkdir -p $(STAGING_DIR)/lib/gcc-lib
	mkdir -p $(STAGING_DIR)/usr/lib
	mkdir -p $(STAGING_DIR)/usr/bin;
	mkdir -p $(STAGING_DIR)/$(GNU_TARGET_NAME)/
	(cd $(STAGING_DIR)/$(GNU_TARGET_NAME); ln -fs ../lib)
	(cd $(STAGING_DIR)/$(GNU_TARGET_NAME); ln -fs ../include)
	(cd $(STAGING_DIR)/$(GNU_TARGET_NAME); ln -fs ../include sys-include)
	(cd $(STAGING_DIR)/usr/lib; ln -fs ../../lib/gcc-lib)
	touch $(STAGING_DIR)/.setup


#############################################################
#
# Setup some initial stuff
#
#############################################################
ifeq ("$(TARGET_LANGUAGES)","c,c++")
STLPORT_TARGET=stlport
endif

uclibc_toolchain: gcc_final

uclibc_toolchain-source: $(DL_DIR)/$(BINUTILS_SOURCE) $(DL_DIR)/$(UCLIBC_SOURCE) \
			    $(DL_DIR)/$(GCC_SOURCE) $(DL_DIR)/$(STLPORT_SOURCE)

uclibc_toolchain-clean: gcc_final-clean uclibc-clean gcc_initial-clean binutils-clean

uclibc_toolchain-dirclean: gcc_final-dirclean uclibc-dirclean gcc_initial-dirclean binutils-dirclean


#############################################################
#
# build binutils
#
#############################################################
BINUTILS_DIR1:=$(TOOL_BUILD_DIR)/binutils-build
$(DL_DIR)/$(BINUTILS_SOURCE):
	$(WGET) -P $(DL_DIR) $(BINUTILS_SITE)/$(BINUTILS_SOURCE)

$(BINUTILS_DIR)/.unpacked: $(DL_DIR)/$(BINUTILS_SOURCE)
	$(BINUTILS_CAT) $(DL_DIR)/$(BINUTILS_SOURCE) | tar -C $(TOOL_BUILD_DIR) -xvf -
	touch $(BINUTILS_DIR)/.unpacked

$(BINUTILS_DIR)/.patched: $(BINUTILS_DIR)/.unpacked
	# Apply any files named binutils-*.patch from the source directory to binutils
	$(SOURCE_DIR)/patch-kernel.sh $(BINUTILS_DIR) $(SOURCE_DIR) binutils-*.patch
	#
	# Hack binutils to use the correct default shared lib loader
	#
	(cd $(BINUTILS_DIR); perl -i -p -e "s,#.*define.*ELF_DYNAMIC_INTERPRETER.*\".*\",\
		#define ELF_DYNAMIC_INTERPRETER \"/lib/ld-uClibc.so.0\",;" \
		`grep -lr ELF_DYNAMIC_INTERPRETER *`);
	touch $(BINUTILS_DIR)/.patched

$(BINUTILS_DIR1)/.configured: $(BINUTILS_DIR)/.patched
	mkdir -p $(BINUTILS_DIR1)
	(cd $(BINUTILS_DIR1); CC=$(HOSTCC) \
		CC_FOR_HOST=$(HOSTCC) \
		CXX_FOR_HOST=$(HOSTCC) \
		$(BINUTILS_DIR)/configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_HOST_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=$(STAGING_DIR) \
		--exec-prefix=$(STAGING_DIR) \
		--bindir=$(STAGING_DIR)/bin \
		--sbindir=$(STAGING_DIR)/sbin \
		--sysconfdir=$(STAGING_DIR)/etc \
		--datadir=$(STAGING_DIR)/share \
		--includedir=$(STAGING_DIR)/include \
		--libdir=$(STAGING_DIR)/lib \
		--localstatedir=$(STAGING_DIR)/var \
		--mandir=$(STAGING_DIR)/man \
		--infodir=$(STAGING_DIR)/info \
		--enable-targets=$(GNU_TARGET_NAME) \
		--with-sysroot=$(STAGING_DIR) \
		--with-lib-path="$(STAGING_DIR)/usr/lib:$(STAGING_DIR)/lib" \
		$(MULTILIB) \
		--program-prefix=$(ARCH)-uclibc-);
	touch $(BINUTILS_DIR1)/.configured

$(BINUTILS_DIR1)/binutils/objdump: $(BINUTILS_DIR1)/.configured
	$(MAKE) CC_FOR_HOST=$(HOSTCC) \
		CXX_FOR_HOST=$(HOSTCC) \
		-C $(BINUTILS_DIR1);

$(STAGING_DIR)/$(GNU_TARGET_NAME)/bin/ld: $(BINUTILS_DIR1)/binutils/objdump 
	$(MAKE) CC_FOR_HOST=$(HOSTCC) \
		CXX_FOR_HOST=$(HOSTCC) \
		-C $(BINUTILS_DIR1) install;
	rm -rf $(STAGING_DIR)/info $(STAGING_DIR)/man $(STAGING_DIR)/share/doc \
		$(STAGING_DIR)/share/locale
	mkdir -p $(STAGING_DIR)/usr/bin;
	set -e; \
	for app in addr2line ar as c++filt gprof ld nm objcopy \
		    objdump ranlib readelf size strings strip ; \
	do \
		if [ -x $(STAGING_DIR)/bin/$(ARCH)-uclibc-$${app} ] ; then \
		    (cd $(STAGING_DIR)/$(GNU_TARGET_NAME)/bin; \
			ln -fs ../../bin/$(ARCH)-uclibc-$${app} $${app}; \
		    ); \
		    (cd $(STAGING_DIR)/usr/bin; \
			ln -fs ../../bin/$(ARCH)-uclibc-$${app} $${app}; \
		    ); \
		fi; \
	done;

$(STAGING_DIR)/lib/libg.a:
	mkdir -p $(STAGING_DIR)/$(GNU_TARGET_NAME)/bin
	$(STAGING_DIR)/$(GNU_TARGET_NAME)/bin/ar rv $(STAGING_DIR)/lib/libg.a;

binutils: $(STAGING_DIR)/$(GNU_TARGET_NAME)/bin/ld $(STAGING_DIR)/lib/libg.a

binutils-clean:
	rm -f $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)*
	-$(MAKE) -C $(BINUTILS_DIR1) clean

binutils-dirclean:
	rm -rf $(BINUTILS_DIR1)




#############################################################
#
# Next build first pass gcc compiler
#
#############################################################
GCC_BUILD_DIR1:=$(TOOL_BUILD_DIR)/gcc-initial
$(DL_DIR)/$(GCC_SOURCE):
	$(WGET) -P $(DL_DIR) $(GCC_SITE)/$(GCC_SOURCE)

$(GCC_DIR)/.unpacked: $(STAGING_DIR)/.setup $(DL_DIR)/$(GCC_SOURCE)
	bzcat $(DL_DIR)/$(GCC_SOURCE) | tar -C $(TOOL_BUILD_DIR) -xvf -
	touch $(GCC_DIR)/.unpacked

$(GCC_DIR)/.patched: $(GCC_DIR)/.unpacked
	# Apply any files named gcc-*.patch from the source directory to gcc
	$(SOURCE_DIR)/patch-kernel.sh $(GCC_DIR) $(SOURCE_DIR) gcc2.95-mega.patch.bz2
	touch $(GCC_DIR)/.patched

$(GCC_DIR)/.gcc_build_hacks: $(GCC_DIR)/.patched
	#
	# Hack things to use the correct shared lib loader
	#
	(cd $(GCC_DIR); set -e; export LIST=`grep -lr -- "-dynamic-linker.*\.so[\.0-9]*" *`;\
		if [ -n "$$LIST" ] ; then \
		perl -i -p -e "s,-dynamic-linker.*\.so[\.0-9]*},\
		    -dynamic-linker /lib/ld-uClibc.so.0},;" $$LIST; fi);
	#
	# Prevent system glibc start files from leaking in uninvited...
	#
	perl -i -p -e "s,standard_startfile_prefix_1 = \".*,standard_startfile_prefix_1 =\
		\"$(STAGING_DIR)/lib/\";,;" $(GCC_DIR)/gcc/gcc.c;
	perl -i -p -e "s,standard_startfile_prefix_2 = \".*,standard_startfile_prefix_2 =\
		\"$(STAGING_DIR)/usr/lib/\";,;" $(GCC_DIR)/gcc/gcc.c;
	#
	# Prevent system glibc include files from leaking in uninvited...
	#
	perl -i -p -e "s,^NATIVE_SYSTEM_HEADER_DIR.*,NATIVE_SYSTEM_HEADER_DIR=\
		$(STAGING_DIR)/include,;" $(GCC_DIR)/gcc/Makefile.in;
	perl -i -p -e "s,^CROSS_SYSTEM_HEADER_DIR.*,CROSS_SYSTEM_HEADER_DIR=\
		$(STAGING_DIR)/include,;" $(GCC_DIR)/gcc/Makefile.in;
	perl -i -p -e "s,^#define.*STANDARD_INCLUDE_DIR.*,#define STANDARD_INCLUDE_DIR \
		\"$(STAGING_DIR)/include\",;" $(GCC_DIR)/gcc/cppdefault.h;
	#
	# Prevent system glibc libraries from being found by collect2 
	# when it calls locatelib() and rummages about the system looking 
	# for libraries with the correct name...
	#
	perl -i -p -e "s,\"/lib,\"$(STAGING_DIR)/lib,g;" $(GCC_DIR)/gcc/collect2.c
	perl -i -p -e "s,\"/usr/,\"$(STAGING_DIR)/usr/,g;" $(GCC_DIR)/gcc/collect2.c
	#
	# Prevent gcc from using the unwind-dw2-fde-glibc code
	#
	perl -i -p -e "s,^#ifndef inhibit_libc,#define inhibit_libc\n\
		#ifndef inhibit_libc,g;" $(GCC_DIR)/gcc/unwind-dw2-fde-glibc.c;
	#
	# Use atexit() directly, rather than cxa_atexit
	#
	perl -i -p -e "s,int flag_use_cxa_atexit = 1;,int flag_use_cxa_atexit = 0;,g;"\
		$(GCC_DIR)/gcc/cp/decl2.c;
	#
	# We do not wish to build the libstdc++ library provided with gcc,
	# since it doesn't seem to work at all with uClibc plus gcc 2.95...
	#
	mv $(GCC_DIR)/libstdc++ $(GCC_DIR)/libstdc++.orig
	mv $(GCC_DIR)/libio $(GCC_DIR)/libio.orig
	touch $(GCC_DIR)/.gcc_build_hacks

# The --without-headers option stopped working with gcc 3.0 and has never been
# # fixed, so we need to actually have working C library header files prior to
# # the step or libgcc will not build...
$(GCC_BUILD_DIR1)/.configured: $(GCC_DIR)/.gcc_build_hacks
	mkdir -p $(GCC_BUILD_DIR1)
	(cd $(GCC_BUILD_DIR1); PATH=$(TARGET_PATH) AR=$(TARGET_CROSS)ar \
		RANLIB=$(TARGET_CROSS)ranlib CC=$(HOSTCC) \
		$(GCC_DIR)/configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_HOST_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=$(STAGING_DIR) \
		--exec-prefix=$(STAGING_DIR) \
		--bindir=$(STAGING_DIR)/bin \
		--sbindir=$(STAGING_DIR)/sbin \
		--sysconfdir=$(STAGING_DIR)/etc \
		--datadir=$(STAGING_DIR)/share \
		--includedir=$(STAGING_DIR)/include \
		--libdir=$(STAGING_DIR)/lib \
		--localstatedir=$(STAGING_DIR)/var \
		--mandir=$(STAGING_DIR)/man \
		--infodir=$(STAGING_DIR)/info \
		--with-local-prefix=$(STAGING_DIR)/usr/local \
		--oldincludedir=$(STAGING_DIR)/include $(MULTILIB) \
		--enable-target-optspace $(DISABLE_NLS) --with-gnu-ld \
		--disable-shared --enable-languages=c --disable-__cxa_atexit \
		$(EXTRA_GCC_CONFIG_OPTIONS) --program-prefix=$(ARCH)-uclibc-);
	touch $(GCC_BUILD_DIR1)/.configured

$(GCC_BUILD_DIR1)/.compiled: $(GCC_BUILD_DIR1)/.configured
	PATH=$(TARGET_PATH) $(MAKE) -C $(GCC_BUILD_DIR1) \
	    AR_FOR_TARGET=$(STAGING_DIR)/bin/$(ARCH)-uclibc-ar \
	    RANLIB_FOR_TARGET=$(STAGING_DIR)/bin/$(ARCH)-uclibc-ranlib
	touch $(GCC_BUILD_DIR1)/.compiled

$(STAGING_DIR)/bin/$(ARCH)-uclibc-gcc: $(GCC_BUILD_DIR1)/.compiled
	PATH=$(TARGET_PATH) $(MAKE) -C $(GCC_BUILD_DIR1) install;
	#Cleanup then mess when --program-prefix mysteriously fails 
	-mv $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-cpp $(STAGING_DIR)/bin/$(ARCH)-uclibc-cpp
	-mv $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-gcc $(STAGING_DIR)/bin/$(ARCH)-uclibc-gcc
	rm -f $(STAGING_DIR)/bin/gccbug $(STAGING_DIR)/bin/gcov
	rm -rf $(STAGING_DIR)/info $(STAGING_DIR)/man $(STAGING_DIR)/share/doc \
		$(STAGING_DIR)/share/locale

gcc_initial: binutils $(UCLIBC_DIR)/.configured $(STAGING_DIR)/bin/$(ARCH)-uclibc-gcc

gcc_initial-clean:
	rm -rf $(GCC_BUILD_DIR1)
	rm -f $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)*

gcc_initial-dirclean:
	rm -rf $(GCC_BUILD_DIR1)



#############################################################
#
# uClibc is built in two stages.  First, we install the uClibc 
# include files so that gcc can be built.  Later when gcc for 
# the target arch has been compiled, we can actually compile 
# uClibc for the target... 
#
#############################################################
$(DL_DIR)/$(UCLIBC_SOURCE):
	$(WGET) -P $(DL_DIR) $(UCLIBC_SITE)/$(UCLIBC_SOURCE)

$(UCLIBC_DIR)/.unpacked: $(STAGING_DIR)/.setup $(DL_DIR)/$(UCLIBC_SOURCE)
	bzcat $(DL_DIR)/$(UCLIBC_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(UCLIBC_DIR)/.unpacked

$(UCLIBC_DIR)/.configured: $(UCLIBC_DIR)/.unpacked $(BUILD_DIR)/linux/.configured
	perl -i -p -e 's,^CROSS=.*,TARGET_ARCH=$(ARCH)\nCROSS=$(TARGET_CROSS),g' \
		$(UCLIBC_DIR)/Rules.mak
	cp $(SOURCE_DIR)/uClibc.config $(UCLIBC_DIR)/.config
	perl -i -p -e 's,^KERNEL_SOURCE=.*,KERNEL_SOURCE=\"$(LINUX_DIR)\",g' \
		$(UCLIBC_DIR)/.config
	perl -i -p -e 's,^DEVEL_PREFIX=.*,DEVEL_PREFIX=\"$(STAGING_DIR)\",g' \
		$(UCLIBC_DIR)/.config
	perl -i -p -e 's,^SYSTEM_DEVEL_PREFIX=.*,SYSTEM_DEVEL_PREFIX=\"$(STAGING_DIR)\",g' \
		$(UCLIBC_DIR)/.config
	perl -i -p -e 's,^DEVEL_TOOL_PREFIX=.*,DEVEL_TOOL_PREFIX=\"$(STAGING_DIR)/usr\",g' \
		$(UCLIBC_DIR)/.config
	perl -i -p -e 's,^SHARED_LIB_LOADER_PATH=.*,SHARED_LIB_LOADER_PATH=\"/lib\",g' \
		$(UCLIBC_DIR)/.config
	perl -i -p -e 's,.*UCLIBC_HAS_WCHAR.*,UCLIBC_HAS_WCHAR=y\nUCLIBC_HAS_LOCALE=n,g' \
		$(UCLIBC_DIR)/.config
	perl -i -p -e 's,^GCC_BIN.*,GCC_BIN=$(STAGING_DIR)/bin/$(ARCH)-uclibc-gcc,g' \
		$(UCLIBC_DIR)/extra/gcc-uClibc/Makefile
	perl -i -p -e 's,^LD_BIN.*,LD_BIN=$(STAGING_DIR)/bin/$(ARCH)-uclibc-ld,g' \
		$(UCLIBC_DIR)/extra/gcc-uClibc/Makefile
	$(MAKE) -C $(UCLIBC_DIR) oldconfig
	$(MAKE) -C $(UCLIBC_DIR) headers install_dev;
	touch $(UCLIBC_DIR)/.configured

$(UCLIBC_DIR)/lib/libc.a: $(UCLIBC_DIR)/.configured
	$(MAKE) -C $(UCLIBC_DIR)

$(STAGING_DIR)/lib/libc.a: $(UCLIBC_DIR)/lib/libc.a
	$(MAKE) -C $(UCLIBC_DIR) install_dev install_runtime install_utils

ifneq ($(TARGET_DIR),)
$(TARGET_DIR)/lib/libc.so.0: $(STAGING_DIR)/lib/libc.a
	$(MAKE) -C $(UCLIBC_DIR) DEVEL_PREFIX=$(TARGET_DIR) \
		SYSTEM_DEVEL_PREFIX=$(TARGET_DIR) \
		DEVEL_TOOL_PREFIX=$(TARGET_DIR)/usr install_runtime

$(TARGET_DIR)/usr/bin/ldd: $(TARGET_DIR)/lib/libc.so.0
	$(MAKE) -C $(UCLIBC_DIR) PREFIX=$(TARGET_DIR) install_target_utils
	(cd $(TARGET_DIR)/sbin; ln -sf /bin/true ldconfig) 

UCLIBC_TARGETS=$(TARGET_DIR)/lib/libc.so.0 $(TARGET_DIR)/usr/bin/ldd
endif

uclibc: $(STAGING_DIR)/bin/$(ARCH)-uclibc-gcc $(STAGING_DIR)/lib/libc.a \
	$(UCLIBC_TARGETS)

uclibc-clean:
	-$(MAKE) -C $(UCLIBC_DIR) clean
	rm -f $(UCLIBC_DIR)/.config

uclibc-dirclean:
	rm -rf $(UCLIBC_DIR)





#############################################################
#
# STLport -- an alternative C++ library
#
#############################################################
STLPORT_PATCH=$(SOURCE_DIR)/STLport-4.5.3.patch
$(DL_DIR)/$(STLPORT_SOURCE):
	$(WGET) -P $(DL_DIR) $(STLPORT_SITE)/$(STLPORT_SOURCE)

$(STLPORT_DIR)/Makefile: $(DL_DIR)/$(STLPORT_SOURCE) $(STLPORT_PATCH)
	zcat $(DL_DIR)/$(STLPORT_SOURCE) | tar -C $(TOOL_BUILD_DIR) -xvf - 
	cat $(STLPORT_PATCH) | patch -d $(STLPORT_DIR) -p1

$(STLPORT_DIR)/lib/libstdc++.a: $(STLPORT_DIR)/Makefile
	$(MAKE) ARCH=$(ARCH) PREFIX=$(STAGING_DIR) -C $(STLPORT_DIR)

$(STAGING_DIR)/lib/libstdc++.a: $(STLPORT_DIR)/lib/libstdc++.a
	$(MAKE) ARCH=$(ARCH) PREFIX=$(STAGING_DIR) -C $(STLPORT_DIR) install
ifneq ($(HAS_MMU),true)
	rm -f $(STAGING_DIR)/lib/libstdc++*.so*
endif

stlport: $(STAGING_DIR)/lib/libstdc++.a

stlport-clean:
	rm -f $(STAGING_DIR)/lib/libstdc++*
	rm -f $(STAGING_DIR)/include/c++*
	-$(MAKE) -C $(STLPORT_DIR) clean

stlport-dirclean:
	rm -f $(STAGING_DIR)/lib/libstdc++*
	rm -f $(STAGING_DIR)/include/g++-v3*
	rm -rf $(STLPORT_DIR)



#############################################################
#
# second pass compiler build.  Build the compiler targeting 
# the newly built shared uClibc library.
#
#############################################################
GCC_BUILD_DIR2:=$(TOOL_BUILD_DIR)/gcc-final
$(GCC_DIR)/.g++_build_hacks: $(GCC_DIR)/.patched
	#
	# Hack up the soname for libstdc++
	# 
	#perl -i -p -e "s,\.so\.1,.so.0.9.9,g;" $(GCC_DIR)/gcc/config/t-slibgcc-elf-ver;
	#perl -i -p -e "s,-version-info.*[0-9]:[0-9]:[0-9],-version-info 9:9:0,g;" \
	#	$(GCC_DIR)/libstdc++-v3/src/Makefile.am $(GCC_DIR)/libstdc++-v3/src/Makefile.in;
	#perl -i -p -e "s,3\.0\.0,9.9.0,g;" $(GCC_DIR)/libstdc++-v3/acinclude.m4 \
	#	$(GCC_DIR)/libstdc++-v3/aclocal.m4 $(GCC_DIR)/libstdc++-v3/configure;
	#
	# For now, we don't support locale-ified ctype (we will soon), 
	# so bypass that problem for now...
	#
	#perl -i -p -e "s,defined.*_GLIBCPP_USE_C99.*,1,g;" \
	#	$(GCC_DIR)/libstdc++-v3/config/locale/generic/c_locale.cc;
	#cp $(GCC_DIR)/libstdc++-v3/config/os/generic/bits/ctype_base.h \
	#	$(GCC_DIR)/libstdc++-v3/config/os/gnu-linux/bits/
	#cp $(GCC_DIR)/libstdc++-v3/config/os/generic/bits/ctype_inline.h \
	#	$(GCC_DIR)/libstdc++-v3/config/os/gnu-linux/bits/
	#cp $(GCC_DIR)/libstdc++-v3/config/os/generic/bits/ctype_noninline.h \
	#	$(GCC_DIR)/libstdc++-v3/config/os/gnu-linux/bits/
	touch $(GCC_DIR)/.g++_build_hacks

$(GCC_BUILD_DIR2)/.configured: $(GCC_DIR)/.g++_build_hacks
	mkdir -p $(GCC_BUILD_DIR2)
	(cd $(GCC_BUILD_DIR2); PATH=$(TARGET_PATH) AR=$(TARGET_CROSS)ar \
		RANLIB=$(TARGET_CROSS)ranlib LD=$(TARGET_CROSS)ld \
		NM=$(TARGET_CROSS)nm CC=$(HOSTCC) \
		$(GCC_DIR)/configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_HOST_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=$(STAGING_DIR) \
		--exec-prefix=$(STAGING_DIR) \
		--bindir=$(STAGING_DIR)/bin \
		--sbindir=$(STAGING_DIR)/sbin \
		--sysconfdir=$(STAGING_DIR)/etc \
		--datadir=$(STAGING_DIR)/share \
		--localstatedir=$(STAGING_DIR)/var \
		--mandir=$(STAGING_DIR)/man \
		--infodir=$(STAGING_DIR)/info \
		--with-local-prefix=$(STAGING_DIR)/usr/local \
		--libdir=$(STAGING_DIR)/lib \
		--includedir=$(STAGING_DIR)/include \
		--with-gxx-include-dir=$(STAGING_DIR)/include/c++ \
		--oldincludedir=$(STAGING_DIR)/include \
		--enable-shared $(MULTILIB) \
		--enable-target-optspace $(DISABLE_NLS) \
		--with-gnu-ld --disable-__cxa_atexit \
		--enable-languages=$(TARGET_LANGUAGES) \
		$(EXTRA_GCC_CONFIG_OPTIONS) \
		--program-prefix=$(ARCH)-uclibc- \
	);
	touch $(GCC_BUILD_DIR2)/.configured

$(GCC_BUILD_DIR2)/.compiled: $(GCC_BUILD_DIR2)/.configured
	PATH=$(TARGET_PATH) CC=$(HOSTCC) \
	    AR_FOR_TARGET=$(TARGET_CROSS)ar RANLIB_FOR_TARGET=$(TARGET_CROSS)ranlib \
	    LD_FOR_TARGET=$(TARGET_CROSS)ld NM_FOR_TARGET=$(TARGET_CROSS)nm \
	    CC_FOR_TARGET=$(TARGET_CROSS)gcc $(MAKE) -C $(GCC_BUILD_DIR2)
	touch $(GCC_BUILD_DIR2)/.compiled

$(GCC_BUILD_DIR2)/.installed: $(GCC_BUILD_DIR2)/.compiled
	touch $(GCC_BUILD_DIR2)/.installed

$(STAGING_DIR)/bin/$(ARCH)-uclibc-g++: $(GCC_BUILD_DIR2)/.compiled
	PATH=$(TARGET_PATH) $(MAKE) -C $(GCC_BUILD_DIR2) install;
	-mv $(STAGING_DIR)/bin/gcc $(STAGING_DIR)/usr/bin;
	-mv $(STAGING_DIR)/bin/protoize $(STAGING_DIR)/usr/bin;
	-mv $(STAGING_DIR)/bin/unprotoize $(STAGING_DIR)/usr/bin;
	-mv $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-cpp $(STAGING_DIR)/bin/$(ARCH)-uclibc-cpp
	-mv $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-gcc $(STAGING_DIR)/bin/$(ARCH)-uclibc-gcc
	-mv $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-c++ $(STAGING_DIR)/bin/$(ARCH)-uclibc-c++
	-mv $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-g++ $(STAGING_DIR)/bin/$(ARCH)-uclibc-g++
	-mv $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-c++filt $(STAGING_DIR)/bin/$(ARCH)-uclibc-c++filt
	rm -f $(STAGING_DIR)/bin/cpp $(STAGING_DIR)/bin/gcov $(STAGING_DIR)/bin/*gccbug
	rm -f $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-$(ARCH)-uclibc-*
	rm -rf $(STAGING_DIR)/info $(STAGING_DIR)/man $(STAGING_DIR)/share/doc \
		$(STAGING_DIR)/share/locale
	# Strip the host binaries
	-strip --strip-all -R .note -R .comment $(STAGING_DIR)/bin/*
	set -e; \
	for app in cc gcc c89 cpp c++ g++ ; do \
		if [ -x $(STAGING_DIR)/bin/$(ARCH)-uclibc-$${app} ] ; then \
		    (cd $(STAGING_DIR)/usr/bin; \
			ln -fs ../../bin/$(ARCH)-uclibc-$${app} $${app}; \
		    ); \
		fi; \
	done;

gcc_final: $(STAGING_DIR)/.setup binutils gcc_initial uclibc \
	$(STAGING_DIR)/bin/$(ARCH)-uclibc-g++ $(STLPORT_TARGET)

gcc_final-clean:
	rm -rf $(GCC_BUILD_DIR2)
	rm -f $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)*

gcc_final-dirclean:
	rm -rf $(GCC_BUILD_DIR2)



#############################################################
#
# Packup the toolchain binaries
#
#############################################################
$(ARCH)-uclibc-toolchain.tar.bz2: gcc_final
	rm -f $(ARCH)-uclibc-toolchain.tar.bz2
	tar -cf $(ARCH)-uclibc-toolchain.tar $(STAGING_DIR)
	bzip2 -9 $(ARCH)-uclibc-toolchain.tar

tarball: $(ARCH)-uclibc-toolchain.tar.bz2

endif
endif
