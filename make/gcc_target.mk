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
TARGET_LANGUAGES:=c,c++

# If you want multilib enabled, enable this...
MULTILIB:=--enable-multilib

ifeq ($(USE_UCLIBC_TOOLCHAIN),true)
GCC_DEPENDANCY=gcc_final
GCC_INSTALL_TARGET=install-gcc
else
BINUTILS_SITE:=ftp://ftp.gnu.org/gnu/binutils/
BINUTILS_SOURCE:=binutils-2.13.2.1.tar.bz2
BINUTILS_DIR:=$(TOOL_BUILD_DIR)/binutils-2.13.2.1

GCC_SITE:=ftp://ftp.gnu.org/gnu/gcc/
GCC_SOURCE:=gcc-3.2.2.tar.gz
GCC_DIR:=$(TOOL_BUILD_DIR)/gcc-3.2.2
GCC_INSTALL_TARGET=install
endif

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
ifneq ($(USE_UCLIBC_TOOLCHAIN),true)
BINUTILS_DIR2_DEPENDS:=$(BINUTILS_DIR)/.patched
$(DL_DIR)/$(BINUTILS_SOURCE):
	$(WGET) -P $(DL_DIR) $(BINUTILS_SITE)/$(BINUTILS_SOURCE)

$(BINUTILS_DIR)/.unpacked: $(DL_DIR)/$(BINUTILS_SOURCE)
	bzcat $(DL_DIR)/$(BINUTILS_SOURCE) | tar -C $(TOOL_BUILD_DIR) -xvf -
	touch $(BINUTILS_DIR)/.unpacked

$(BINUTILS_DIR)/.patched: $(BINUTILS_DIR)/.unpacked
	# Apply any files named binutils-*.patch from the source directory to binutils
	$(SOURCE_DIR)/patch-kernel.sh $(BINUTILS_DIR) $(SOURCE_DIR) binutils-*.patch
	#
	# Enable combreloc, since it is such a nice thing to have...
	#
	-perl -i -p -e "s,link_info.combreloc = false,link_info.combreloc = true,g;" \
		$(BINUTILS_DIR)/ld/ldmain.c
	#
	# Hack binutils to use the correct shared lib loader
	#
	(cd $(BINUTILS_DIR); perl -i -p -e "s,#.*define.*ELF_DYNAMIC_INTERPRETER.*\".*\"\
		,#define ELF_DYNAMIC_INTERPRETER \"/lib/ld-uClibc.so.0\",;" \
		`grep -lr "#.*define.*ELF_DYNAMIC_INTERPRETER.*\".*\"" $(BINUTILS_DIR)`);
	touch $(BINUTILS_DIR)/.patched
endif

$(BINUTILS_DIR2)/.configured: $(BINUTILS_DIR2_DEPENDS)
	mkdir -p $(BINUTILS_DIR2)
	mkdir -p $(TARGET_DIR)/usr/include
	mkdir -p $(TARGET_DIR)/usr/$(GNU_TARGET_NAME)/
	(cd $(TARGET_DIR)/usr/$(GNU_TARGET_NAME); ln -fs ../include sys-include)
	(cd $(BINUTILS_DIR2); PATH=$(TARGET_PATH) \
		CC=$(HOSTCC) \
		AR_FOR_TARGET=$(TARGET_CROSS)ar \
		AS_FOR_TARGET=$(TARGET_CROSS)as \
		LD_FOR_TARGET=$(TARGET_CROSS)ld \
		NM_FOR_TARGET=$(TARGET_CROSS)nm \
		CC_FOR_TARGET=$(TARGET_CROSS)gcc \
		GCC_FOR_TARGET=$(TARGET_CROSS)gcc \
		CXX_FOR_TARGET=$(TARGET_CROSS)g++ \
		RANLIB_FOR_TARGET=$(TARGET_CROSS)ranlib \
		$(BINUTILS_DIR)/configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--libdir=/usr/lib \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--includedir=$(STAGING_DIR)/include \
		--with-gxx-include-dir=$(STAGING_DIR)/include/c++ \
		--enable-shared $(MULTILIB) \
		--program-prefix="" \
	);
	touch $(BINUTILS_DIR2)/.configured

$(BINUTILS_DIR2)/binutils/objdump: $(BINUTILS_DIR2)/.configured
	$(MAKE) tooldir=/usr -C $(BINUTILS_DIR2)

$(TARGET_DIR)/usr/bin/ld: $(BINUTILS_DIR2)/binutils/objdump 
	$(MAKE) \
	    prefix=$(TARGET_DIR)/usr \
	    exec_prefix=$(TARGET_DIR)/usr \
	    bindir=$(TARGET_DIR)/usr/bin \
	    sbindir=$(TARGET_DIR)/usr/sbin \
	    libexecdir=$(TARGET_DIR)/usr/lib \
	    datadir=$(TARGET_DIR)/usr/share \
	    sysconfdir=$(TARGET_DIR)/etc \
	    sharedstatedir=$(TARGET_DIR)/usr/com \
	    localstatedir=$(TARGET_DIR)/var \
	    libdir=$(TARGET_DIR)/usr/lib \
	    infodir=$(TARGET_DIR)/usr/info \
	    mandir=$(TARGET_DIR)/usr/man \
	    includedir=$(TARGET_DIR)/usr/include \
	    gxx_include_dir=$(TARGET_DIR)/usr/include/c++ \
	    toolexecdir=$(TARGET_DIR)/lib/gcc-lib/$(GNU_TARGET_NAME) \
	-C $(BINUTILS_DIR2) install;
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc
	-$(STRIP) $(TARGET_DIR)/usr/$(GNU_TARGET_NAME)/bin/*
	-$(STRIP) $(TARGET_DIR)/usr/bin/* 

$(TARGET_DIR)/usr/lib/libg.a:
	$(TARGET_CROSS)ar rv $(TARGET_DIR)/usr/lib/libg.a;
	cp $(BINUTILS_DIR)/include/ansidecl.h $(TARGET_DIR)/usr/include/
	cp $(BINUTILS_DIR)/include/bfdlink.h $(TARGET_DIR)/usr/include/
	cp $(BINUTILS_DIR)/include/dis-asm.h $(TARGET_DIR)/usr/include/
	cp $(BINUTILS_DIR)/include/libiberty.h $(TARGET_DIR)/usr/include/
	cp $(BINUTILS_DIR)/include/symcat.h $(TARGET_DIR)/usr/include/
	cp $(BINUTILS_DIR2)/bfd/bfd.h $(TARGET_DIR)/usr/include/
	cp -a $(BINUTILS_DIR2)/bfd/.libs/* $(TARGET_DIR)/usr/lib/
	cp -a $(BINUTILS_DIR2)/opcodes/.libs/* $(TARGET_DIR)/usr/lib/
	cp -a $(BINUTILS_DIR2)/libiberty/libiberty.a $(TARGET_DIR)/usr/lib/

binutils_target: $(GCC_DEPENDANCY) $(TARGET_DIR)/usr/bin/ld $(TARGET_DIR)/usr/lib/libg.a

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

$(TARGET_DIR)/usr/lib/libc.a: $(STAGING_DIR)/lib/libc.a
	$(MAKE) DEVEL_PREFIX=$(TARGET_DIR)/usr SYSTEM_DEVEL_PREFIX=$(TARGET_DIR) \
		DEVEL_TOOL_PREFIX=$(TARGET_DIR) -C $(UCLIBC_DIR) \
		install_dev
	#remove the extra copy of the shared libs
	rm -f $(TARGET_DIR)/usr/lib/*-*.so
	(cd $(TARGET_DIR)/usr/lib; \
		ln -fs /lib/libc.so.0 libc.so; \
		ln -fs /lib/libdl.so.0 libdl.so; \
		ln -fs /lib/libcrypt.so.0 libcrypt.so; \
		ln -fs /lib/libresolv.so.0 libresolv.so; \
		ln -fs /lib/libutil.so.0 libutil.so; \
		ln -fs /lib/libm.so.0 libm.so; \
		ln -fs /lib/libpthread.so.0 libpthread.so; \
		ln -fs /lib/libnsl.so.0 libnsl.so; \
	)

uclibc_target: $(GCC_DEPENDANCY) $(TARGET_DIR)/usr/lib/libc.a

uclibc_target-clean:
	rm -f $(TARGET_DIR)/include

uclibc_target-dirclean:
	rm -f $(TARGET_DIR)/include



#############################################################
#
# Next build target gcc compiler
#
#############################################################
ifneq ($(USE_UCLIBC_TOOLCHAIN),true)
GCC_DIR3_DEPENDS:=$(GCC_DIR)/.g++_build_hacks
$(DL_DIR)/$(GCC_SOURCE):
	$(WGET) -P $(DL_DIR) $(GCC_SITE)/$(GCC_SOURCE)

$(GCC_DIR)/.unpacked: $(DL_DIR)/$(GCC_SOURCE)
	zcat $(DL_DIR)/$(GCC_SOURCE) | tar -C $(TOOL_BUILD_DIR) -xvf -
	touch $(GCC_DIR)/.unpacked

$(GCC_DIR)/.patched: $(GCC_DIR)/.unpacked
	# Apply any files named gcc-*.patch from the source directory to gcc
	$(SOURCE_DIR)/patch-kernel.sh $(GCC_DIR) $(SOURCE_DIR) gcc-*.patch
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
	# Prevent gcc from using the unwind-dw2-fde-glibc code
	#
	perl -i -p -e "s,^#ifndef inhibit_libc,#define inhibit_libc\n\
		#ifndef inhibit_libc,g;" $(GCC_DIR)/gcc/unwind-dw2-fde-glibc.c;
	touch $(GCC_DIR)/.gcc_build_hacks

$(GCC_DIR)/.g++_build_hacks: $(GCC_DIR)/.gcc_build_hacks
	#
	# Hack up the soname for libstdc++
	# 
	perl -i -p -e "s,\.so\.1,.so.0.9.9,g;" $(GCC_DIR)/gcc/config/t-slibgcc-elf-ver;
	perl -i -p -e "s,-version-info.*[0-9]:[0-9]:[0-9],-version-info 9:9:0,g;" \
		$(GCC_DIR)/libstdc++-v3/src/Makefile.am $(GCC_DIR)/libstdc++-v3/src/Makefile.in;
	perl -i -p -e "s,3\.0\.0,9.9.0,g;" $(GCC_DIR)/libstdc++-v3/acinclude.m4 \
		$(GCC_DIR)/libstdc++-v3/aclocal.m4 $(GCC_DIR)/libstdc++-v3/configure;
	#
	# For now, we don't support locale-ified ctype (we will soon), 
	# so bypass that problem for now...
	#
	perl -i -p -e "s,defined.*_GLIBCPP_USE_C99.*,1,g;" \
		$(GCC_DIR)/libstdc++-v3/config/locale/generic/c_locale.cc;
	cp $(GCC_DIR)/libstdc++-v3/config/os/generic/bits/ctype_base.h \
		$(GCC_DIR)/libstdc++-v3/config/os/gnu-linux/bits/
	cp $(GCC_DIR)/libstdc++-v3/config/os/generic/bits/ctype_inline.h \
		$(GCC_DIR)/libstdc++-v3/config/os/gnu-linux/bits/
	cp $(GCC_DIR)/libstdc++-v3/config/os/generic/bits/ctype_noninline.h \
		$(GCC_DIR)/libstdc++-v3/config/os/gnu-linux/bits/
	touch $(GCC_DIR)/.g++_build_hacks
endif

$(GCC_BUILD_DIR3)/.gcc_build_hacks: $(GCC_DIR3_DEPENDS)
	#
	# Make certain the uClibc start files are found
	#
	perl -i -p -e "s,standard_startfile_prefix_1 = \".*,standard_startfile_prefix_1=\
		\"/lib/\";,;" $(GCC_DIR)/gcc/gcc.c;
	perl -i -p -e "s,standard_startfile_prefix_2 = \".*,standard_startfile_prefix_2=\
		\"/usr/lib/\";,;" $(GCC_DIR)/gcc/gcc.c;
	#
	# Make certain the uClibc include files are found
	#
	perl -i -p -e "s,^NATIVE_SYSTEM_HEADER_DIR.*,NATIVE_SYSTEM_HEADER_DIR=\
		/usr/include,;" $(GCC_DIR)/gcc/Makefile.in;
	perl -i -p -e "s,^CROSS_SYSTEM_HEADER_DIR.*,CROSS_SYSTEM_HEADER_DIR=\
		/usr/include,;" $(GCC_DIR)/gcc/Makefile.in;
	perl -i -p -e "s,^#define.*STANDARD_INCLUDE_DIR.*,#define STANDARD_INCLUDE_DIR \
		\"/usr/include\",;" $(GCC_DIR)/gcc/cppdefault.h;
	mkdir -p $(GCC_BUILD_DIR3)
	touch $(GCC_BUILD_DIR3)/.gcc_build_hacks

$(GCC_BUILD_DIR3)/.configured: $(GCC_BUILD_DIR3)/.gcc_build_hacks
	mkdir -p $(TARGET_DIR)/usr/lib/gcc-lib
	mkdir -p $(TARGET_DIR)/usr/$(GNU_TARGET_NAME)
	(cd $(TARGET_DIR)/usr/$(GNU_TARGET_NAME); ln -fs ../include)
	(cd $(TARGET_DIR)/usr/$(GNU_TARGET_NAME); ln -fs ../include sys-include)
	(cd $(GCC_BUILD_DIR3); PATH=$(TARGET_PATH) \
		CC=$(HOSTCC) \
		AR_FOR_TARGET=$(TARGET_CROSS)ar \
		AS_FOR_TARGET=$(TARGET_CROSS)as \
		LD_FOR_TARGET=$(TARGET_CROSS)ld \
		NM_FOR_TARGET=$(TARGET_CROSS)nm \
		CC_FOR_TARGET=$(TARGET_CROSS)gcc \
		GCC_FOR_TARGET=$(TARGET_CROSS)gcc \
		CXX_FOR_TARGET=$(TARGET_CROSS)g++ \
		RANLIB_FOR_TARGET=$(TARGET_CROSS)ranlib \
		$(GCC_DIR)/configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--with-local-prefix=/usr/local \
		--libdir=/usr/lib \
		--includedir=$(TARGET_DIR)/usr/include \
		--with-gxx-include-dir=$(TARGET_DIR)/usr/include/c++ \
		--disable-shared $(MULTILIB) \
		--enable-target-optspace --disable-nls \
		--with-gnu-ld --disable-__cxa_atexit \
		--enable-languages=$(TARGET_LANGUAGES) \
		$(EXTRA_GCC_CONFIG_OPTIONS) \
		--program-prefix="" \
	);
	touch $(GCC_BUILD_DIR3)/.configured

$(GCC_BUILD_DIR3)/.compiled: $(GCC_BUILD_DIR3)/.configured
	$(MAKE) -C $(GCC_BUILD_DIR3)
	touch $(GCC_BUILD_DIR3)/.compiled

$(TARGET_DIR)/usr/bin/gcc: $(GCC_BUILD_DIR3)/.compiled
	$(MAKE) \
	    prefix=$(TARGET_DIR)/usr \
	    exec_prefix=$(TARGET_DIR)/usr \
	    bindir=$(TARGET_DIR)/usr/bin \
	    sbindir=$(TARGET_DIR)/usr/sbin \
	    libexecdir=$(TARGET_DIR)/usr/libexec \
	    datadir=$(TARGET_DIR)/usr/share \
	    sysconfdir=$(TARGET_DIR)/etc \
	    sharedstatedir=$(TARGET_DIR)/usr/com \
	    localstatedir=$(TARGET_DIR)/var \
	    libdir=$(TARGET_DIR)/usr/lib \
	    includedir=$(TARGET_DIR)/usr/include \
	    oldincludedir=$(TARGET_DIR)/usr/include \
	    infodir=$(TARGET_DIR)/usr/info \
	    mandir=$(TARGET_DIR)/usr/man \
	    gxx_include_dir=$(TARGET_DIR)/usr/include/c++ \
	    tooldir=$(TARGET_DIR)/usr/$(GNU_TARGET_NAME) \
	    build_tooldir=$(TARGET_DIR)/usr/$(GNU_TARGET_NAME) \
	    -C $(GCC_BUILD_DIR3) $(GCC_INSTALL_TARGET);
	(cd $(TARGET_DIR)/usr/bin; ln -fs gcc cc)
	(cd $(TARGET_DIR)/lib; ln -fs /usr/bin/cpp)
	rm -rf $(TARGET_DIR)/usr/$(GNU_TARGET_NAME)/include
	rm -rf $(TARGET_DIR)/usr/$(GNU_TARGET_NAME)/sys-include
	rm -rf $(TARGET_DIR)/usr/include/include $(TARGET_DIR)/usr/usr
	-mv $(TARGET_DIR)/usr/bin/$(GNU_TARGET_NAME)-cpp $(TARGET_DIR)/usr/bin/cpp
	-mv $(TARGET_DIR)/usr/bin/$(GNU_TARGET_NAME)-gcc $(TARGET_DIR)/usr/bin/gcc
	-mv $(TARGET_DIR)/usr/bin/$(GNU_TARGET_NAME)-c++ $(TARGET_DIR)/usr/bin/c++
	-mv $(TARGET_DIR)/usr/bin/$(GNU_TARGET_NAME)-g++ $(TARGET_DIR)/usr/bin/g++
	-mv $(TARGET_DIR)/usr/bin/$(GNU_TARGET_NAME)-c++filt $(TARGET_DIR)/usr/bin/c++filt
	-cp -dpf $(STAGING_DIR)/lib/libgcc* $(TARGET_DIR)/lib/
	-chmod a-x $(STAGING_DIR)/lib/*++*
	-cp -a $(STAGING_DIR)/lib/*++* $(TARGET_DIR)/lib/
	-cp -a $(STAGING_DIR)/include/c++ $(TARGET_DIR)/usr/include/
	-mv $(TARGET_DIR)/lib/*.a $(TARGET_DIR)/usr/lib/
	-mv $(TARGET_DIR)/lib/*.la $(TARGET_DIR)/usr/lib/
	rm -f $(TARGET_DIR)/lib/libstdc++.so
	-(cd $(TARGET_DIR)/usr/lib; ln -fs /lib/libstdc++.so.5.0.2 libstdc++.so)
	-$(STRIP) $(TARGET_DIR)/bin/* 
	-$(STRIP) $(TARGET_DIR)/usr/bin/* 
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc
	rm -f $(TARGET_DIR)/usr/lib/*.la*
	# gcc "fixincludes" step is totally broken and takes unwanted
	# stuff from the host system.  Fix that here.
ifeq ($(USE_UCLIBC_TOOLCHAIN),true)
	rm -rf $(TARGET_DIR)/usr/lib/gcc-lib/$(GNU_TARGET_NAME)/*/include/*
	-cp -a $(STAGING_DIR)/usr/lib/gcc-lib/$(GNU_TARGET_NAME)/*/include/* \
		$(TARGET_DIR)/usr/lib/gcc-lib/$(GNU_TARGET_NAME)/*/include/
endif
	touch -c $(TARGET_DIR)/usr/bin/gcc

gcc_target: uclibc_target binutils_target $(TARGET_DIR)/usr/bin/gcc

gcc_target-clean:
	rm -rf $(GCC_BUILD_DIR3)
	rm -f $(TARGET_DIR)/bin/$(GNU_TARGET_NAME)*

gcc_target-dirclean:
	rm -rf $(GCC_BUILD_DIR3)

