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

ifeq ($(GCC_2_95_TOOLCHAIN),true)

GCC_SITE:=http://www.uclibc.org/downloads/toolchain
GCC_SOURCE:=gcc-20011006.tar.bz2
GCC_DIR:=$(TOOL_BUILD_DIR)/gcc-20011006
GCC_CAT:=bzcat

STLPORT_SITE=http://www.stlport.org/archive
STLPORT_SOURCE=STLport-4.5.3.tar.gz
STLPORT_DIR=$(TOOL_BUILD_DIR)/STLport-4.5.3



#############################################################
#
# Setup some initial stuff
#
#############################################################
ifeq ($(INSTALL_LIBSTDCPP),true)
TARGET_LANGUAGES:=c,c++
STLPORT_TARGET=stlport
else
TARGET_LANGUAGES:=c
STLPORT_TARGET=
endif

#############################################################
#
# Next build first pass gcc compiler
#
#############################################################
GCC_BUILD_DIR1:=$(TOOL_BUILD_DIR)/gcc-2.95-initial

$(DL_DIR)/$(GCC_SOURCE):
	$(WGET) -P $(DL_DIR) $(GCC_SITE)/$(GCC_SOURCE)

$(GCC_DIR)/.unpacked: $(DL_DIR)/$(GCC_SOURCE)
	$(GCC_CAT) $(DL_DIR)/$(GCC_SOURCE) | tar -C $(TOOL_BUILD_DIR) -xvf -
	touch $(GCC_DIR)/.unpacked

$(GCC_DIR)/.patched: $(GCC_DIR)/.unpacked
	# Apply any files named gcc-*.patch from the source directory to gcc
	$(SOURCE_DIR)/patch-kernel.sh $(GCC_DIR) $(SOURCE_DIR) gcc2.95-mega.patch.bz2
	touch $(GCC_DIR)/.patched

$(GCC_DIR)/.gcc2_95_build_hacks: $(GCC_DIR)/.patched
	#
	# Hack things to use the correct shared lib loader
	#
	(cd $(GCC_DIR); set -e; export LIST=`grep -lr -- "-dynamic-linker.*\.so[\.0-9]*" *`;\
		if [ -n "$$LIST" ] ; then \
		sed -ie "s,-dynamic-linker.*\.so[\.0-9]*},\
		    -dynamic-linker /lib/ld-uClibc.so.0},;" $$LIST; fi);
	#
	# Prevent system glibc start files from leaking in uninvited...
	#
	sed -ie "s,standard_startfile_prefix_1 = \".*,standard_startfile_prefix_1 =\
		\"$(STAGING_DIR)/lib/\";,;" $(GCC_DIR)/gcc/gcc.c;
	sed -ie "s,standard_startfile_prefix_2 = \".*,standard_startfile_prefix_2 =\
		\"$(STAGING_DIR)/usr/lib/\";,;" $(GCC_DIR)/gcc/gcc.c;
	#
	# Prevent system glibc include files from leaking in uninvited...
	#
	sed -ie "s,^NATIVE_SYSTEM_HEADER_DIR.*,NATIVE_SYSTEM_HEADER_DIR=\
		$(STAGING_DIR)/include,;" $(GCC_DIR)/gcc/Makefile.in;
	sed -ie "s,^CROSS_SYSTEM_HEADER_DIR.*,CROSS_SYSTEM_HEADER_DIR=\
		$(STAGING_DIR)/include,;" $(GCC_DIR)/gcc/Makefile.in;
	sed -ie "s,^#define.*STANDARD_INCLUDE_DIR.*,#define STANDARD_INCLUDE_DIR \
		\"$(STAGING_DIR)/include\",;" $(GCC_DIR)/gcc/cppdefault.h;
	#
	# Prevent system glibc libraries from being found by collect2 
	# when it calls locatelib() and rummages about the system looking 
	# for libraries with the correct name...
	#
	sed -ie "s,\"/lib,\"$(STAGING_DIR)/lib,g;" $(GCC_DIR)/gcc/collect2.c
	sed -ie "s,\"/usr/,\"$(STAGING_DIR)/usr/,g;" $(GCC_DIR)/gcc/collect2.c
	#
	# Prevent gcc from using the unwind-dw2-fde-glibc code
	#
	sed -ie "s,^#ifndef inhibit_libc,#define inhibit_libc\n\
		#ifndef inhibit_libc,g;" $(GCC_DIR)/gcc/unwind-dw2-fde-glibc.c;
	#
	# Use atexit() directly, rather than cxa_atexit
	#
	sed -ie "s,int flag_use_cxa_atexit = 1;,int flag_use_cxa_atexit = 0;,g;"\
		$(GCC_DIR)/gcc/cp/decl2.c;
	#
	# We do not wish to build the libstdc++ library provided with gcc,
	# since it doesn't seem to work at all with uClibc plus gcc 2.95...
	#
	mv $(GCC_DIR)/libstdc++ $(GCC_DIR)/libstdc++.orig
	mv $(GCC_DIR)/libio $(GCC_DIR)/libio.orig
	touch $(GCC_DIR)/.gcc2_95_build_hacks

# The --without-headers option stopped working with gcc 3.0 and has never been
# fixed, so we need to actually have working C library header files prior to
# the step or libgcc will not build...
$(GCC_BUILD_DIR1)/.configured: $(GCC_DIR)/.gcc2_95_build_hacks
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

gcc2_95_initial: binutils $(UCLIBC_DIR)/.configured $(STAGING_DIR)/bin/$(ARCH)-uclibc-gcc

gcc2_95_initial-clean:
	rm -rf $(GCC_BUILD_DIR1)
	rm -f $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)*

gcc2_95_initial-dirclean:
	rm -rf $(GCC_BUILD_DIR1)



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

stlport-source: $(DL_DIR)/$(STLPORT_SOURCE)

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
GCC_BUILD_DIR2:=$(TOOL_BUILD_DIR)/gcc-2.95-final
$(GCC_DIR)/.g++_build_hacks: $(GCC_DIR)/.patched
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

gcc2_95: binutils uclibc-configured gcc2_95_initial uclibc \
	$(STAGING_DIR)/bin/$(ARCH)-uclibc-g++ $(STLPORT_TARGET)

gcc2_95-source: $(DL_DIR)/$(GCC_SOURCE)

gcc2_95-clean:
	rm -rf $(GCC_BUILD_DIR2)
	rm -f $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)*

gcc2_95-dirclean:
	rm -rf $(GCC_BUILD_DIR2)

endif
