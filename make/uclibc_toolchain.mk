# Makefile for to build a gcc/uClibc toolchain
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

ifeq ($(USE_UCLIBC_TOOLCHAIN),true)
#############################################################
#
# EDIT this stuff to suit your system and source locations
#
#############################################################

# C compiler for the build system
HOSTCC:=gcc

# Set this to `false' if you are building for a CPU does not have
# a memory management unit (MMU) -- i.e. an uClinux system..  If
# you are targeting a regular Linux system, leave this "true".
# Set Most people will leave this set to "true".
HAS_MMU:=true


# Enable this to use the uClibc daily snapshot instead of a released
# version.  Daily snapshots may contain new features and bugfixes. Or
# they may not even compile at all, depending on what Erik is doing...
USE_UCLIBC_SNAPSHOT:=true
#############################################################
#
# You should probably leave this stuff alone unless you are
# hacking on the toolchain...
#
#############################################################
GNU_TARGET_NAME:=$(ARCH)-linux
MAKE:=make

NATIVE_ARCH:= ${shell uname -m | sed \
		-e 's/i.86/i386/' \
		-e 's/sparc.*/sparc/' \
		-e 's/arm.*/arm/g' \
		-e 's/m68k.*/m68k/' \
		-e 's/ppc/powerpc/g' \
		-e 's/v850.*/v850/g' \
		-e 's/sh[234].*/sh/' \
		-e 's/mips.*/mips/' \
		}
ifeq ($(strip $(ARCH)),$(strip $(NATIVE_ARCH)))
CROSSARG=
else
CROSSARG=--cross=$(ARCH)-uclibc-
endif
ifneq ($(HAS_MMU),true)
NOMMU:=nommu
endif


#############################################################
#
# Where we can find things....
#
# for various dependancy reasons, these need to live
# here at the top...  Easier to find things here anyways...
#
#############################################################
BINUTILS_SITE:=ftp://ftp.gnu.org/gnu/binutils/
BINUTILS_SOURCE:=binutils-2.12.1.tar.bz2
BINUTILS_DIR:=$(BUILD_DIR)/binutils-2.12.1

ifeq ($(USE_UCLIBC_SNAPSHOT),true)
# Be aware that this changes daily....
UCLIBC_DIR=$(BUILD_DIR)/uClibc
UCLIBC_SOURCE=uClibc-snapshot.tar.bz2
else
UCLIBC_DIR:=$(BUILD_DIR)/uClibc-0.9.12
UCLIBC_SOURCE:=uClibc-0.9.12.tar.bz2
endif
UCLIBC_SITE:=ftp://www.uclibc.org/uClibc

GCC_SITE:=ftp://ftp.gnu.org/gnu/gcc/
GCC_SOURCE:=gcc-3.1.tar.gz
GCC_DIR:=$(BUILD_DIR)/gcc-3.1
GCC_BUILD_DIR1:=$(BUILD_DIR)/gcc-initial
GCC_BUILD_DIR2:=$(BUILD_DIR)/gcc-final



#############################################################
#
# Setup some initial paths
#
#############################################################
$(BUILD_DIR)/.setup:
	mkdir -p $(BUILD_DIR)
	mkdir -p $(DL_DIR)
	mkdir -p $(STAGING_DIR)
	mkdir -p $(STAGING_DIR)/include
	mkdir -p $(STAGING_DIR)/lib/gcc-lib
	mkdir -p $(STAGING_DIR)/$(GNU_TARGET_NAME)/
	(cd $(STAGING_DIR)/$(GNU_TARGET_NAME); ln -fs ../lib)
	(cd $(STAGING_DIR)/$(GNU_TARGET_NAME); ln -fs ../include)
	(cd $(STAGING_DIR)/$(GNU_TARGET_NAME); ln -fs ../include sys-include)
	mkdir -p $(STAGING_DIR)/usr/lib
	(cd $(STAGING_DIR)/usr/lib; ln -fs ../../lib/gcc-lib)
	touch $(BUILD_DIR)/.setup


#############################################################
#
# Setup some initial stuff
#
#############################################################
uclibc_toolchain: gcc_final

uclibc_toolchain-clean: gcc_final-clean uclibc-clean gcc_initial-clean binutils-clean

uclibc_toolchain-dirclean: gcc_final-dirclean uclibc-dirclean gcc_initial-dirclean binutils-dirclean



#############################################################
#
# Setup the kernel headers, but don't compile anything for the target yet,
# since we still need to build a cross-compiler to do that little task for
# us...  Try to work around this little chicken-and-egg problem..
#
#############################################################
ifeq ($(LINUX_DIR),)
LINUX_DIR:=$(BUILD_DIR)/linux
endif
$(LINUX_DIR)/.cross_compiler_set: $(BUILD_DIR)/.setup $(LINUX_DIR)/.configured
	perl -i -p -e "s,^CROSS_COMPILE.*,\
		CROSS_COMPILE=$(STAGING_DIR)/bin/$(ARCH)-uclibc-,g;" \
		$(LINUX_DIR)/Makefile
	touch $(LINUX_DIR)/.cross_compiler_set

linux_headers: $(LINUX_DIR)/.cross_compiler_set


#############################################################
#
# build binutils
#
#############################################################
$(DL_DIR)/$(BINUTILS_SOURCE):
	wget -P $(DL_DIR) --passive-ftp $(BINUTILS_SITE)/$(BINUTILS_SOURCE)

$(BINUTILS_DIR)/.unpacked: $(BUILD_DIR)/.setup $(DL_DIR)/$(BINUTILS_SOURCE)
	bzcat $(DL_DIR)/$(BINUTILS_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(BINUTILS_DIR)/.unpacked

$(BINUTILS_DIR)/.patched: $(BINUTILS_DIR)/.unpacked
	# Apply all binutils patches in the source directory, named binutils-*.patch
	for p in $(SOURCE_DIR)/binutils-*.patch ; do \
		cat $$p | patch -p1 -d $(BINUTILS_DIR) ; \
	done
	@if [ "`find $(BINUTILS_DIR) '(' -name '*.rej' -o -name '.*.rej' ')' -print`" ] ; then \
	    echo "Aborting.  Reject files found."; \
	    exit 1; \
	fi
	touch $(BINUTILS_DIR)/.patched

$(BINUTILS_DIR)/.configured: $(BINUTILS_DIR)/.patched
	(cd $(BINUTILS_DIR); perl -i -p -e "s,#.*define.*ELF_DYNAMIC_INTERPRETER.*\".*\"\
		,#define ELF_DYNAMIC_INTERPRETER \"/lib/ld-uClibc.so.0\",;" \
		`grep -lr "#.*define.*ELF_DYNAMIC_INTERPRETER.*\".*\"" $(BINUTILS_DIR)`);
	(cd $(BINUTILS_DIR); CC=$(HOSTCC) ./configure --disable-shared \
		--target=$(GNU_TARGET_NAME) --prefix=$(STAGING_DIR) \
		--enable-targets=$(GNU_TARGET_NAME) \
		--program-transform-name=s,^,$(ARCH)-uclibc-,);
	touch $(BINUTILS_DIR)/.configured

$(BINUTILS_DIR)/binutils/objdump: $(BINUTILS_DIR)/.configured
	$(MAKE) -C $(BINUTILS_DIR);

$(STAGING_DIR)/$(GNU_TARGET_NAME)/bin/ld: $(BINUTILS_DIR)/binutils/objdump 
	$(MAKE) -C $(BINUTILS_DIR) install
	rm -rf $(STAGING_DIR)/info $(STAGING_DIR)/man $(STAGING_DIR)/share

$(STAGING_DIR)/lib/libg.a:
	$(STAGING_DIR)/$(GNU_TARGET_NAME)/bin/ar rv $(STAGING_DIR)/lib/libg.a;

binutils: linux_headers $(STAGING_DIR)/$(GNU_TARGET_NAME)/bin/ld $(STAGING_DIR)/lib/libg.a

binutils-clean:
	rm -f $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)*
	-$(MAKE) -C $(BINUTILS_DIR) clean

binutils-dirclean:
	rm -rf $(BINUTILS_DIR)




#############################################################
#
# Next build first pass gcc compiler
#
#############################################################
$(DL_DIR)/$(GCC_SOURCE):
	wget -P $(DL_DIR) --passive-ftp $(GCC_SITE)/$(GCC_SOURCE)

$(GCC_DIR)/.unpacked: $(BUILD_DIR)/.setup $(DL_DIR)/$(GCC_SOURCE)
	zcat $(DL_DIR)/$(GCC_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(GCC_DIR)/.unpacked

$(GCC_DIR)/.patched: $(GCC_DIR)/.unpacked
	# Apply all gcc patches in the source directory, named gcc-*.patch
	for p in $(SOURCE_DIR)/gcc-*.patch ; do \
		cat $$p | patch -p1 -d $(GCC_DIR) ; \
	done
	@if [ "`find $(GCC_DIR) '(' -name '*.rej' -o -name '.*.rej' ')' -print`" ] ; then \
	    echo "Aborting.  Reject files found."; \
	    exit 1; \
	fi
	touch $(GCC_DIR)/.patched

$(GCC_BUILD_DIR1)/.configured: $(GCC_DIR)/.patched
	mkdir -p $(GCC_BUILD_DIR1)
	(cd $(GCC_BUILD_DIR1); PATH=$$PATH:$(STAGING_DIR)/bin AR=$(ARCH)-uclibc-ar \
		RANLIB=$(ARCH)-uclibc-ranlib CC=$(HOSTCC) $(GCC_DIR)/configure \
		--target=$(GNU_TARGET_NAME) --prefix=$(STAGING_DIR) \
		--enable-target-optspace --disable-nls --with-gnu-ld \
		--disable-shared --enable-languages=c \
		--program-transform-name='s/^$(GNU_TARGET_NAME)-/$(ARCH)-uclibc-/');
	-perl -i -p -e "s,ac_cv_prog_cc_cross=no,ac_cv_prog_cc_cross=yes,g;" $(GCC_BUILD_DIR1)/config.cache
	touch $(GCC_BUILD_DIR1)/.configured

$(GCC_BUILD_DIR1)/.compiled: $(GCC_BUILD_DIR1)/.configured
	PATH=$$PATH:$(STAGING_DIR)/bin $(MAKE) -C $(GCC_BUILD_DIR1);
	touch $(GCC_BUILD_DIR1)/.compiled

$(GCC_BUILD_DIR1)/.installed: $(GCC_BUILD_DIR1)/.compiled
	PATH=$$PATH:$(STAGING_DIR)/bin $(MAKE) -C $(GCC_BUILD_DIR1) install;
	#Cleanup then mess when --program-transform-name mysteriously fails 
	-mv $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-cpp $(STAGING_DIR)/bin/$(ARCH)-uclibc-cpp
	-mv $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-gcc $(STAGING_DIR)/bin/$(ARCH)-uclibc-gcc
	rm -f $(STAGING_DIR)/bin/gccbug $(STAGING_DIR)/bin/gcov
	rm -rf $(STAGING_DIR)/info $(STAGING_DIR)/man $(STAGING_DIR)/share
	touch $(GCC_BUILD_DIR1)/.installed

gcc_initial: binutils $(UCLIBC_DIR)/.configured $(GCC_BUILD_DIR1)/.installed

gcc_initial-clean:
	rm -rf $(GCC_BUILD_DIR1)
	rm -f $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)*

gcc_initial-dirclean:
	rm -rf $(GCC_BUILD_DIR1)



#############################################################
#
# uClibc is built in two stages.  First, we hack the uClibc 
# include files and such in preparation for a gcc build.  Later
# when gcc for the target arch has been compiled, we can then
# actually compile uClibc for the target... 
#
#############################################################
$(DL_DIR)/$(UCLIBC_SOURCE):
	wget -P $(DL_DIR) $(UCLIBC_SITE)/$(UCLIBC_SOURCE)

$(UCLIBC_DIR)/.unpacked: $(BUILD_DIR)/.setup $(DL_DIR)/$(UCLIBC_SOURCE)
	bzcat $(DL_DIR)/$(UCLIBC_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(UCLIBC_DIR)/.unpacked

$(UCLIBC_DIR)/.configured: $(UCLIBC_DIR)/.unpacked
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
		--mmu=$(HAS_MMU) \
		--debug=false \
		--ldso_path="/lib" \
		--shared_support=$(HAS_MMU) \
		--file=$(UCLIBC_DIR)/Config~ \
		> $(UCLIBC_DIR)/Config; 
	perl -i -p -e 's,^SYSTEM_DEVEL_PREFIX.*,SYSTEM_DEVEL_PREFIX=$(STAGING_DIR),g' \
		$(UCLIBC_DIR)/Config
	perl -i -p -e 's,^DEVEL_TOOL_PREFIX.*,DEVEL_TOOL_PREFIX=$(STAGING_DIR)/usr,g' \
		$(UCLIBC_DIR)/Config
	perl -i -p -e 's,^HAS_WCHAR.*,HAS_WCHAR=true,g' $(UCLIBC_DIR)/Config
	# Note that since the target compiler does not yet exist, we will not
	# be able to properly generate include/bits/syscall.h so we will need
	# to run part again later...
	$(MAKE) -C $(UCLIBC_DIR) headers uClibc_config install_dev;
	touch $(UCLIBC_DIR)/.configured

# Now that we have a working target compiler, rebuild the header files for the
# target so things like include/bits/syscall.h can actually be built this time
# around...
$(UCLIBC_DIR)/.config_final: $(UCLIBC_DIR)/.configured
	$(MAKE) -C $(UCLIBC_DIR) headers uClibc_config install_dev;
	touch $(UCLIBC_DIR)/.config_final

$(UCLIBC_DIR)/lib/libc.a: $(UCLIBC_DIR)/.config_final
	$(MAKE) -C $(UCLIBC_DIR)

$(STAGING_DIR)/lib/libc.a: $(UCLIBC_DIR)/lib/libc.a
	$(MAKE) -C $(UCLIBC_DIR) install_dev install_runtime

$(TARGET_DIR)/lib/libc.so.0: $(STAGING_DIR)/lib/libc.a
	$(MAKE) -C $(UCLIBC_DIR) DEVEL_PREFIX=$(TARGET_DIR) \
		SYSTEM_DEVEL_PREFIX=$(TARGET_DIR) \
		DEVEL_TOOL_PREFIX=$(TARGET_DIR)/usr \
		install_runtime

$(TARGET_DIR)/usr/bin/ldd: $(TARGET_DIR)/lib/libc.so.0
	$(MAKE) -C $(UCLIBC_DIR) PREFIX=$(TARGET_DIR) install_target_utils

uclibc: gcc_initial $(STAGING_DIR)/lib/libc.a $(TARGET_DIR)/lib/libc.so.0 $(TARGET_DIR)/usr/bin/ldd

uclibc-clean:
	-$(MAKE) -C $(UCLIBC_DIR) clean
	rm -f $(UCLIBC_DIR)/Config

uclibc-dirclean:
	rm -rf $(UCLIBC_DIR)





#############################################################
#
# second pass compiler build.  Build the compiler targeting 
# the newly built shared uClibc library.
#
#############################################################
$(GCC_DIR)/.ldso_hacks: $(GCC_DIR)/.patched
	# Hack things to use the correct shared lib loader
	(cd $(GCC_DIR); set -e; export LIST=`grep -lr -- "-dynamic-linker.*ld-linux.so.[0-9]" *`;\
		if [ -n "$$LIST" ] ; then \
		perl -i -p -e "s,-dynamic-linker.*ld-linux.so.*[0-9]},\
		    -dynamic-linker /lib/ld-uClibc.so.0},;" $$LIST; fi);
	(cd $(GCC_DIR); set -e; export LIST=`grep -lr ":gcrt1.o%s}" *`; \
		if [ -n "$$LIST" ] ; then \
		perl -i -p -e "s,:gcrt1.o%s},:crt0.o%s},g;" \
		$$LIST; fi);
	(cd $(GCC_DIR); set -e; export LIST=`grep -lr ":crt1.o%s}" *`; \
		if [ -n "$$LIST" ] ; then \
		perl -i -p -e "s,:crt1.o%s},:crt0.o%s},g;" \
		$$LIST; fi);
	# Fixup where gcc looks for start files to prevent glibc stuff leaking in...
	perl -i -p -e "s,standard_startfile_prefix_1 = \".*,standard_startfile_prefix_1=\
		\"$(STAGING_DIR)/lib/\";,;" $(GCC_DIR)/gcc/gcc.c;
	perl -i -p -e "s,standard_startfile_prefix_2 = \".*,standard_startfile_prefix_2=\
		\"$(STAGING_DIR)/usr/lib/\";,;" $(GCC_DIR)/gcc/gcc.c;
	# Use atexit() directly, rather than cxa_atexit
	perl -i -p -e "s,int flag_use_cxa_atexit = 1;,int flag_use_cxa_atexit = 0;,g;"\
		$(GCC_DIR)/gcc/cp/decl2.c;
	# Fix up a lame quirk...
	perl -i -p -e "s,defined.*_GLIBCPP_USE_C99.*,1,g;" $(GCC_DIR)/libstdc++-v3/config/locale/generic/c_locale.cc;
	# Hack up the soname for libstdc++
	perl -i -p -e "s,\.so\.1,.so.0.9.9,g;" $(GCC_DIR)/gcc/config/t-slibgcc-elf-ver;
	perl -i -p -e "s,-version-info.*[0-9]:[0-9]:[0-9],-version-info 9:9:0,g;" \
		$(GCC_DIR)/libstdc++-v3/src/Makefile.am $(GCC_DIR)/libstdc++-v3/src/Makefile.in;
	perl -i -p -e "s,3\.0\.0,9.9.0,g;" $(GCC_DIR)/libstdc++-v3/acinclude.m4 \
		$(GCC_DIR)/libstdc++-v3/aclocal.m4 $(GCC_DIR)/libstdc++-v3/configure;
	# For now, we don't support locale-ified ctype, so bypass that problem here
	cp $(GCC_DIR)/libstdc++-v3/config/os/generic/bits/ctype_base.h \
		$(GCC_DIR)/libstdc++-v3/config/os/gnu-linux/bits/
	cp $(GCC_DIR)/libstdc++-v3/config/os/generic/bits/ctype_inline.h \
		$(GCC_DIR)/libstdc++-v3/config/os/gnu-linux/bits/
	cp $(GCC_DIR)/libstdc++-v3/config/os/generic/bits/ctype_noninline.h \
		$(GCC_DIR)/libstdc++-v3/config/os/gnu-linux/bits/
	touch $(GCC_DIR)/.ldso_hacks

$(GCC_BUILD_DIR2)/.configured: $(GCC_DIR)/.ldso_hacks
	mkdir -p $(GCC_BUILD_DIR2)
	(cd $(GCC_BUILD_DIR2); PATH=$$PATH:$(STAGING_DIR)/bin AR=$(ARCH)-uclibc-ar \
		RANLIB=$(ARCH)-uclibc-ranlib CC=$(HOSTCC) $(GCC_DIR)/configure \
		--target=$(GNU_TARGET_NAME) --prefix=$(STAGING_DIR) \
		--enable-target-optspace --disable-nls --with-gnu-ld \
		--disable-shared --enable-languages=c,c++ \
		--program-transform-name='s/^$(GNU_TARGET_NAME)-/$(ARCH)-uclibc-/');
	perl -i -p -e "s,ac_cv_prog_cc_cross=no,ac_cv_prog_cc_cross=yes,g;" $(GCC_BUILD_DIR2)/config.cache
	touch $(GCC_BUILD_DIR2)/.configured

$(GCC_BUILD_DIR2)/.compiled: $(GCC_BUILD_DIR2)/.configured
	PATH=$$PATH:$(STAGING_DIR)/bin $(MAKE) -C $(GCC_BUILD_DIR2)
	touch $(GCC_BUILD_DIR2)/.compiled

$(GCC_BUILD_DIR2)/.installed: $(GCC_BUILD_DIR2)/.compiled
	PATH=$$PATH:$(STAGING_DIR)/bin $(MAKE) -C $(GCC_BUILD_DIR2) install;
	touch $(GCC_BUILD_DIR2)/.installed

#Cleanup then mess when --program-transform-name mysteriously fails 
$(GCC_BUILD_DIR2)/.fixedup: $(GCC_BUILD_DIR2)/.installed
ifeq ($(strip $(ARCH)),$(strip $(NATIVE_ARCH)))
	-mv $(STAGING_DIR)/bin/gcc $(STAGING_DIR)/$(GNU_TARGET_NAME)/bin;
	-mv $(STAGING_DIR)/bin/protoize $(STAGING_DIR)/$(GNU_TARGET_NAME)/bin;
	-mv $(STAGING_DIR)/bin/unprotoize $(STAGING_DIR)/$(GNU_TARGET_NAME)/bin;
endif
	-mv $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-cpp $(STAGING_DIR)/bin/$(ARCH)-uclibc-cpp
	-mv $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-gcc $(STAGING_DIR)/bin/$(ARCH)-uclibc-gcc
	-mv $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-c++ $(STAGING_DIR)/bin/$(ARCH)-uclibc-c++
	-mv $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-g++ $(STAGING_DIR)/bin/$(ARCH)-uclibc-g++
	-mv $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-c++filt $(STAGING_DIR)/bin/$(ARCH)-uclibc-c++filt
	rm -f $(STAGING_DIR)/bin/cpp $(STAGING_DIR)/bin/gcov $(STAGING_DIR)/bin/*gccbug
	rm -rf $(STAGING_DIR)/info $(STAGING_DIR)/man $(STAGING_DIR)/share
	touch $(GCC_BUILD_DIR2)/.fixedup

$(BUILD_DIR)/.shuffled: $(GCC_BUILD_DIR2)/.fixedup
	mkdir -p $(STAGING_DIR)/usr/bin;
	(set -e; cd $(STAGING_DIR)/usr/bin; \
		for i in $(STAGING_DIR)/bin/* ; do \
		j=`basename $$i`; \
		k=`basename $$i| sed -e "s,$(ARCH)-uclibc-,,g"`; \
		ln -fs ../../bin/$$j $$k; \
	done)
	(set -e; cd $(STAGING_DIR)/$(GNU_TARGET_NAME)/bin; \
		for i in $(STAGING_DIR)/bin/* ; do \
		j=`basename $$i`; \
		k=`basename $$i| sed -e "s,$(ARCH)-uclibc-,,g"`; \
		ln -fs ../../bin/$$j $$k; \
	done)
	touch $(BUILD_DIR)/.shuffled

$(BUILD_DIR)/.stripped: $(BUILD_DIR)/.shuffled
	-strip --strip-all -R .note -R .comment $(STAGING_DIR)/bin/*
	-$(STAGING_DIR)/bin/$(ARCH)-uclibc-strip --strip-unneeded \
		-R .note -R .comment $(STAGING_DIR)/lib/*.so*;
	touch $(BUILD_DIR)/.stripped

#gcc_final: uclibc $(BUILD_DIR)/.stripped
gcc_final: uclibc $(BUILD_DIR)/.shuffled

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
$(GNU_TARGET_NAME)-toolchain.tar.bz2:
	rm -f $(GNU_TARGET_NAME)-toolchain.tar.bz2
	tar -cf $(GNU_TARGET_NAME)-toolchain.tar $(STAGING_DIR)
	bzip2 -9 $(GNU_TARGET_NAME)-toolchain.tar

tarball: $(GNU_TARGET_NAME)-toolchain.tar.bz2

endif
