# Makefile for to build a gcc/uClibc toolchain
#
# Copyright (C) 2002-2003 Erik Andersen <andersen@uclibc.org>
# Copyright (C) 2004 Manuel Novoa III <mjn3@uclibc.org>
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

ifeq ($(BR2_TOOLCHAIN_BUILDROOT),y)

# without sysroot support. Sysroot toolchain is gcc-uclibc-4.x.mk
ifneq ($(BR2_TOOLCHAIN_SYSROOT),y)

ifeq ($(GCC_SNAP_DATE),)
GCC_OFFICIAL_VER:=$(GCC_VERSION)
GCC_SITE:=http://ftp.gnu.org/gnu/gcc/gcc-$(GCC_VERSION)
#GCC_SITE:=ftp://ftp.ibiblio.org/pub/mirrors/gnu/ftp/gnu/gcc/gcc-$(GCC_OFFICIAL_VER)
else
GCC_OFFICIAL_VER:=$(GCC_VERSION)-$(GCC_SNAP_DATE)
GCC_SITE:=ftp://sources.redhat.com/pub/gcc/snapshots/$(GCC_OFFICIAL_VER)
endif


# redefine if using an external prepatched gcc source
ifeq	($(BR2_TOOLCHAIN_NORMAL),)
GCC_SITE:=$(VENDOR_SITE)
GCC_OFFICIAL_VER:=$(GCC_VERSION)$(VENDOR_SUFFIX)$(VENDOR_GCC_RELEASE)
endif

GCC_SOURCE:=gcc-$(GCC_OFFICIAL_VER).tar.bz2
GCC_DIR:=$(TOOL_BUILD_DIR)/gcc-$(GCC_OFFICIAL_VER)

ifeq	($(BR2_TOOLCHAIN_NORMAL),y)
ifeq ($(GCC_SNAP_DATE),)
GCC_PATCH_DIR:=toolchain/gcc/$(GCC_VERSION)
else
ifneq ($(wildcard toolchain/gcc/$(GCC_OFFICIAL_VER)),)
GCC_PATCH_DIR:=toolchain/gcc/$(GCC_OFFICIAL_VER)
else
GCC_PATCH_DIR:=toolchain/gcc/$(GCC_VERSION)
endif
endif
else
GCC_PATCH_DIR:=$(VENDOR_PATCH_DIR)/gcc-$(GCC_OFFICIAL_VER)
endif


GCC_CAT:=$(BZCAT)
GCC_STRIP_HOST_BINARIES:=true


ifeq ($(findstring 3.,$(GCC_VERSION)),3.)
GCC_NO_MPFR:=y
else
ifneq ($(BR2_INSTALL_FORTRAN),y)
# fortran needs gmp and mpfr
ifeq ($(findstring 4.0.,$(GCC_VERSION)),4.0.)
GCC_NO_MPFR:=y
endif
ifeq ($(findstring 4.1.,$(GCC_VERSION)),4.1.)
GCC_NO_MPFR:=y
endif
endif
endif

#############################################################
#
# Setup some initial stuff
#
#############################################################

GCC_TARGET_LANGUAGES:=c

ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
GCC_TARGET_LANGUAGES:=$(GCC_TARGET_LANGUAGES),c++
endif

ifeq ($(BR2_INSTALL_LIBGCJ),y)
GCC_TARGET_LANGUAGES:=$(GCC_TARGET_LANGUAGES),java
endif

ifeq ($(BR2_INSTALL_OBJC),y)
GCC_TARGET_LANGUAGES:=$(GCC_TARGET_LANGUAGES),objc
endif

GCC_TARGET_PREREQ =
GCC_STAGING_PREREQ= $(STAGING_DIR)/usr/lib/libc.a

ifndef GCC_NO_MPFR
GCC_WITH_HOST_GMP=--with-gmp=$(GMP_HOST_DIR)
GCC_WITH_HOST_MPFR=--with-mpfr=$(MPFR_HOST_DIR)

ifeq ($(BR2_INSTALL_FORTRAN),y)
GCC_TARGET_LANGUAGES:=$(GCC_TARGET_LANGUAGES),fortran
#GCC_TARGET_PREREQ += $(TARGET_DIR)/lib/libmpfr.so $(TARGET_DIR)/lib/libgmp.so
#GCC_STAGING_PREREQ+= $(TOOL_BUILD_DIR)/mpfr/lib/libmpfr.so
GCC_WITH_TARGET_GMP=--with-gmp="$(GMP_TARGET_DIR)"
GCC_WITH_TARGET_MPFR=--with-mpfr="$(MPFR_TARGET_DIR)"
endif
endif # ifndef GCC_NO_MPFR

ifeq ($(BR2_GCC_SHARED_LIBGCC),y)
GCC_SHARED_LIBGCC:=--enable-shared
else
GCC_SHARED_LIBGCC:=--disable-shared
endif

ifneq ($(BR2_ENABLE_LOCALE),y)
GCC_ENABLE_CLOCALE:=--disable-clocale
endif


#############################################################
#
# build the first pass gcc compiler
#
#############################################################
GCC_BUILD_DIR1:=$(TOOL_BUILD_DIR)/gcc-$(GCC_VERSION)-initial

$(DL_DIR)/$(GCC_SOURCE):
	mkdir -p $(DL_DIR)
	$(WGET) -P $(DL_DIR) $(GCC_SITE)/$(GCC_SOURCE)

gcc-unpacked: $(GCC_DIR)/.patched
$(GCC_DIR)/.unpacked: $(DL_DIR)/$(GCC_SOURCE)
	mkdir -p $(TOOL_BUILD_DIR)
	$(GCC_CAT) $(DL_DIR)/$(GCC_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(GCC_DIR)
	touch $@

gcc-patched: $(GCC_DIR)/.patched
$(GCC_DIR)/.patched: $(GCC_DIR)/.unpacked
	# Apply any files named gcc-*.patch from the source directory to gcc
	toolchain/patch-kernel.sh $(GCC_DIR) $(GCC_PATCH_DIR) \*.patch
	# Note: The soft float situation has improved considerably with gcc 3.4.x.
	# We can dispense with the custom spec files, as well as libfloat for the arm case.
	# However, we still need a patch for arm.  There's a similar patch for gcc 3.3.x
	# which needs to be integrated so we can kill of libfloat for good, except for
	# anyone (?) who might still be using gcc 2.95.  mjn3
ifeq ($(BR2_SOFT_FLOAT),y)
ifeq ("$(strip $(ARCH))","arm")
	toolchain/patch-kernel.sh $(GCC_DIR) toolchain/gcc/$(GCC_VERSION) arm-softfloat.patch.conditional
endif
ifeq ("$(strip $(ARCH))","armeb")
	toolchain/patch-kernel.sh $(GCC_DIR) toolchain/gcc/$(GCC_VERSION) arm-softfloat.patch.conditional
endif
	# Not yet updated to 3.4.1.
	#ifeq ("$(strip $(ARCH))","i386")
	#toolchain/patch-kernel.sh $(GCC_DIR) toolchain/gcc i386-gcc-soft-float.patch
	#endif
endif
	touch $@

# The --without-headers option stopped working with gcc 3.0 and has never been
# fixed, so we need to actually have working C library header files prior to
# the step or libgcc will not build...

$(GCC_BUILD_DIR1)/.configured: $(GCC_DIR)/.patched
	-mkdir -p $(GCC_BUILD_DIR1)
	(cd $(GCC_BUILD_DIR1); PATH=$(TARGET_PATH) \
		CC="$(HOSTCC)" \
		$(GCC_DIR)/configure \
		--prefix=$(STAGING_DIR)/usr \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_HOST_NAME) \
		--target=$(REAL_GNU_TARGET_NAME) \
		--enable-languages=c \
		--with-sysroot=$(TOOL_BUILD_DIR)/uClibc_dev/ \
		--disable-__cxa_atexit \
		--enable-target-optspace \
		--with-gnu-ld \
		--disable-shared \
		$(GCC_WITH_HOST_GMP) \
		$(GCC_WITH_HOST_MPFR) \
		$(DISABLE_NLS) \
		$(THREADS) \
		$(MULTILIB) \
		$(SOFT_FLOAT_CONFIG_OPTION) \
		$(GCC_WITH_ABI) $(GCC_WITH_ARCH) $(GCC_WITH_TUNE) \
		$(EXTRA_GCC_CONFIG_OPTIONS));
	touch $@

$(GCC_BUILD_DIR1)/.compiled: $(GCC_BUILD_DIR1)/.configured
	PATH=$(TARGET_PATH) $(MAKE) -C $(GCC_BUILD_DIR1) all-gcc
	touch $@

$(STAGING_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)-gcc: $(GCC_BUILD_DIR1)/.compiled
	PATH=$(TARGET_PATH) $(MAKE) -C $(GCC_BUILD_DIR1) install-gcc
	#rm -f $(STAGING_DIR)/bin/gccbug $(STAGING_DIR)/bin/gcov
	#rm -rf $(STAGING_DIR)/info $(STAGING_DIR)/man $(STAGING_DIR)/share/doc $(STAGING_DIR)/share/locale

gcc_initial: uclibc-configured binutils $(STAGING_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)-gcc

gcc_initial-clean:
	rm -rf $(GCC_BUILD_DIR1)

gcc_initial-dirclean:
	rm -rf $(GCC_BUILD_DIR1) $(GCC_DIR)

#############################################################
#
# second pass compiler build.  Build the compiler targeting
# the newly built shared uClibc library.
#
#############################################################
#
# Sigh... I had to rework things because using --with-gxx-include-dir
# causes issues with include dir search order for g++.  This seems to
# have something to do with "path translations" and possibly doesn't
# affect gcc-target.  However, I haven't tested gcc-target yet so no
# guarantees.  mjn3
comma:=,
GCC_BUILD_DIR2:=$(TOOL_BUILD_DIR)/gcc-$(GCC_VERSION)-final
$(GCC_BUILD_DIR2)/.configured: $(GCC_DIR)/.patched $(GCC_STAGING_PREREQ)
	-mkdir -p $(GCC_BUILD_DIR2)
	# Important!  Required for limits.h to be fixed.
	ln -snf ../include $(STAGING_DIR)/usr/$(REAL_GNU_TARGET_NAME)/sys-include
	#-rmdir $(STAGING_DIR)/usr/$(REAL_GNU_TARGET_NAME)/lib
	#ln -snf ../lib/ $(STAGING_DIR)/usr/$(REAL_GNU_TARGET_NAME)/lib
	(cd $(GCC_BUILD_DIR2); rm -rf config.cache ; \
		$(HOST_CONFIGURE_OPTS) \
		LDFLAGS_FOR_TARGET="$(patsubst %,LDFLAGS+=-Wl$(comma)%,$(TARGET_LDFLAGS)) -L$(STAGING_DIR)/lib -L$(STAGING_DIR)/usr/lib" \
		$(GCC_DIR)/configure \
		--prefix=$(STAGING_DIR) \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_HOST_NAME) \
		--target=$(REAL_GNU_TARGET_NAME) \
		--enable-languages=$(GCC_TARGET_LANGUAGES) \
		--disable-__cxa_atexit \
		--enable-target-optspace \
		--with-gnu-ld \
		$(GCC_WITH_HOST_GMP) \
		$(GCC_WITH_HOST_MPFR) \
		$(GCC_SHARED_LIBGCC) \
		$(DISABLE_NLS) \
		$(THREADS) \
		$(MULTILIB) \
		$(SOFT_FLOAT_CONFIG_OPTION) \
		$(GCC_WITH_ABI) $(GCC_WITH_ARCH) $(GCC_WITH_TUNE) \
		$(GCC_USE_SJLJ_EXCEPTIONS) \
		$(DISABLE_LARGEFILE) \
		$(EXTRA_GCC_CONFIG_OPTIONS));
	touch $@

$(GCC_BUILD_DIR2)/.compiled: $(GCC_BUILD_DIR2)/.configured
	PATH=$(TARGET_PATH) $(MAKE) -C $(GCC_BUILD_DIR2) all
	touch $@

$(GCC_BUILD_DIR2)/.installed: $(GCC_BUILD_DIR2)/.compiled
	PATH=$(TARGET_PATH) $(MAKE) -C $(GCC_BUILD_DIR2) install
	if [ -d "$(STAGING_DIR)/usr/lib64" ] ; then \
		if [ ! -e "$(STAGING_DIR)/usr/lib" ] ; then \
			mkdir "$(STAGING_DIR)/usr/lib" ; \
		fi ; \
		mv "$(STAGING_DIR)/usr/lib64/"* "$(STAGING_DIR)/usr/lib/" ; \
		rmdir "$(STAGING_DIR)/usr/lib64" ; \
	fi
	# Strip the host binaries
ifeq ($(GCC_STRIP_HOST_BINARIES),true)
	-strip --strip-all -R .note -R .comment $(STAGING_DIR)/usr/bin/*
endif
	# Make sure we have 'cc'.
	if [ ! -e $(STAGING_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)-cc ] ; then \
		ln -snf $(REAL_GNU_TARGET_NAME)-gcc \
			$(STAGING_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)-cc ; \
	fi;
	if [ ! -e $(STAGING_DIR)/usr/bin/gcc ] ; then \
		ln -snf gcc $(STAGING_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)-cc ; \
	fi;
	# Set up the symlinks to enable lying about target name.
	set -e; \
	(cd $(STAGING_DIR)/usr; \
		ln -snf $(REAL_GNU_TARGET_NAME) $(GNU_TARGET_NAME); \
		cd bin; \
		for app in $(REAL_GNU_TARGET_NAME)-* ; do \
			ln -snf $${app} \
		   	$(GNU_TARGET_NAME)$${app##$(REAL_GNU_TARGET_NAME)}; \
		done; \
	);
	#
	# Now for the ugly 3.3.x soft float hack...
	#
ifeq ($(BR2_SOFT_FLOAT),y)
ifeq ($(findstring 3.3.,$(GCC_VERSION)),3.3.)
	# Make sure we have a soft float specs file for this arch
	if [ ! -f toolchain/gcc/$(GCC_VERSION)/specs-$(ARCH)-soft-float ] ; then \
		echo soft float configured but no specs file for this arch ; \
		/bin/false ; \
	fi;
	# Replace specs file with one that defaults to soft float mode.
	if [ ! -f $(STAGING_DIR)/usr/lib/gcc-lib/$(REAL_GNU_TARGET_NAME)/$(GCC_VERSION)/specs ] ; then \
		echo staging dir specs file is missing ; \
		/bin/false ; \
	fi;
	cp toolchain/gcc/$(GCC_VERSION)/specs-$(ARCH)-soft-float $(STAGING_DIR)/usr/lib/gcc-lib/$(REAL_GNU_TARGET_NAME)/$(GCC_VERSION)/specs
endif
endif
	#
	# Ok... that's enough of that.
	#
	touch $@

$(GCC_BUILD_DIR2)/.libs_installed: $(GCC_BUILD_DIR2)/.installed
ifeq ($(BR2_GCC_SHARED_LIBGCC),y)
	# These are in /lib, so...
	rm -rf $(TARGET_DIR)/usr/lib/libgcc_s*.so*
	-cp -dpf $(STAGING_DIR)/usr/$(REAL_GNU_TARGET_NAME)/lib/libgcc_s* $(TARGET_DIR)/lib/
	$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libgcc_s*
endif
ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
	-cp -dpf $(STAGING_DIR)/lib/libstdc++.so* $(TARGET_DIR)/usr/lib/
	$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/libstdc++.so*
endif
ifeq ($(BR2_INSTALL_LIBGCJ),y)
	-cp -dpf $(STAGING_DIR)/lib/libgcj.so* $(TARGET_DIR)/usr/lib/
	-cp -dpf $(STAGING_DIR)/lib/lib-org-w3c-dom.so* $(TARGET_DIR)/usr/lib/
	-cp -dpf $(STAGING_DIR)/lib/lib-org-xml-sax.so* $(TARGET_DIR)/usr/lib/
	-mkdir -p $(TARGET_DIR)/usr/lib/security
	-cp -dpf $(STAGING_DIR)/usr/lib/security/libgcj.security $(TARGET_DIR)/usr/lib/security/
	-cp -dpf $(STAGING_DIR)/usr/lib/security/classpath.security $(TARGET_DIR)/usr/lib/security/
endif
	touch $@

gcc: uclibc-configured binutils gcc_initial $(LIBFLOAT_TARGET) uclibc \
	$(GCC_BUILD_DIR2)/.installed $(GCC_BUILD_DIR2)/.libs_installed \
	$(GCC_TARGETS)

gcc-source: $(DL_DIR)/$(GCC_SOURCE)

gcc-clean:
	rm -rf $(GCC_BUILD_DIR2)
	for prog in cpp gcc gcc-[0-9]* protoize unprotoize gcov gccbug cc; do \
	    rm -f $(STAGING_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)-$$prog \
	    rm -f $(STAGING_DIR)/usr/bin/$(GNU_TARGET_NAME)-$$prog; \
	done

gcc-dirclean: gcc_initial-dirclean
	rm -rf $(GCC_BUILD_DIR2)

#############################################################
#
# Next build target gcc compiler
#
#############################################################
GCC_BUILD_DIR3:=$(BUILD_DIR)/gcc-$(GCC_VERSION)-target

$(GCC_BUILD_DIR3)/.prepared: $(GCC_BUILD_DIR2)/.libs_installed $(GCC_TARGET_PREREQ)
	mkdir -p $(GCC_BUILD_DIR3)
	touch $@

$(GCC_BUILD_DIR3)/.configured: $(GCC_BUILD_DIR3)/.prepared
	(cd $(GCC_BUILD_DIR3); rm -rf config.cache ; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS_FOR_BUILD="-g -O2 $(HOST_CFLAGS)" \
		$(TARGET_GCC_FLAGS) \
		$(GCC_DIR)/configure \
		--prefix=/usr \
		--build=$(GNU_HOST_NAME) \
		--host=$(REAL_GNU_TARGET_NAME) \
		--target=$(REAL_GNU_TARGET_NAME) \
		--enable-languages=$(GCC_TARGET_LANGUAGES) \
		--with-gxx-include-dir=/usr/include/c++ \
		--disable-__cxa_atexit \
		--with-gnu-ld \
		$(GCC_SHARED_LIBGCC) \
		$(GCC_WITH_TARGET_GMP) \
		$(GCC_WITH_TARGET_MPFR) \
		$(DISABLE_NLS) \
		$(THREADS) \
		$(MULTILIB) \
		$(SOFT_FLOAT_CONFIG_OPTION) \
		$(GCC_WITH_ABI) $(GCC_WITH_ARCH) $(GCC_WITH_TUNE) \
		$(GCC_USE_SJLJ_EXCEPTIONS) \
		$(DISABLE_LARGEFILE) \
		$(EXTRA_GCC_CONFIG_OPTIONS) \
		$(EXTRA_TARGET_GCC_CONFIG_OPTIONS));
	touch $@

$(GCC_BUILD_DIR3)/.compiled: $(GCC_BUILD_DIR3)/.configured
	PATH=$(TARGET_PATH) \
	$(MAKE) -C $(GCC_BUILD_DIR3) all
	touch $@

#
# gcc-lib dir changes names to gcc with 3.4.mumble
#
ifeq ($(findstring 3.4.,$(GCC_VERSION)),3.4.)
GCC_LIB_SUBDIR=lib/gcc/$(REAL_GNU_TARGET_NAME)/$(GCC_VERSION)
else
GCC_LIB_SUBDIR=lib/gcc-lib/$(REAL_GNU_TARGET_NAME)/$(GCC_VERSION)
endif
# sigh... we need to find a better way
ifeq ($(findstring 4.0.,$(GCC_VERSION)),4.0.)
GCC_LIB_SUBDIR=lib/gcc/$(REAL_GNU_TARGET_NAME)/$(GCC_VERSION)
endif
ifeq ($(findstring 4.1.,$(GCC_VERSION)),4.1.)
GCC_LIB_SUBDIR=lib/gcc/$(REAL_GNU_TARGET_NAME)/$(GCC_VERSION)
endif
ifeq ($(findstring 4.2,$(GCC_VERSION)),4.2)
ifneq ($(findstring 4.2.,$(GCC_VERSION)),4.2.)
REAL_GCC_VERSION=$(shell cat $(GCC_DIR)/gcc/BASE-VER)
GCC_LIB_SUBDIR=lib/gcc/$(REAL_GNU_TARGET_NAME)/$(REAL_GCC_VERSION)
else
GCC_LIB_SUBDIR=lib/gcc/$(REAL_GNU_TARGET_NAME)/$(GCC_VERSION)
endif
endif

$(TARGET_DIR)/usr/bin/gcc: $(GCC_BUILD_DIR3)/.compiled
	PATH=$(TARGET_PATH) \
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(GCC_BUILD_DIR3) install
	# Remove broken specs file (cross compile flag is set).
	rm -f $(TARGET_DIR)/usr/$(GCC_LIB_SUBDIR)/specs
	#
	# Now for the ugly 3.3.x soft float hack...
	#
ifeq ($(BR2_SOFT_FLOAT),y)
ifeq ($(findstring 3.3.,$(GCC_VERSION)),3.3.)
	# Add a specs file that defaults to soft float mode.
	cp toolchain/gcc/$(GCC_VERSION)/specs-$(ARCH)-soft-float $(TARGET_DIR)/usr/lib/gcc-lib/$(REAL_GNU_TARGET_NAME)/$(GCC_VERSION)/specs
	# Make sure gcc does not think we are cross compiling
	$(SED) "s/^1/0/;" $(TARGET_DIR)/usr/lib/gcc-lib/$(REAL_GNU_TARGET_NAME)/$(GCC_VERSION)/specs
endif
endif
	#
	# Ok... that's enough of that.
	#
	-(cd $(TARGET_DIR)/bin && find -type f | xargs $(STRIP) > /dev/null 2>&1)
	-(cd $(TARGET_DIR)/usr/bin && find -type f | xargs $(STRIP) > /dev/null 2>&1)
	-(cd $(TARGET_DIR)/usr/$(GCC_LIB_SUBDIR) && $(STRIP) cc1 cc1plus collect2 > /dev/null 2>&1)
	-(cd $(TARGET_DIR)/usr/lib && $(STRIP) libstdc++.so.*.*.* > /dev/null 2>&1)
	-(cd $(TARGET_DIR)/lib && $(STRIP) libgcc_s*.so.*.*.* > /dev/null 2>&1)
	#
	rm -f $(TARGET_DIR)/usr/lib/*.la*
	#rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
	#	$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc
	# Work around problem of missing syslimits.h
	if [ ! -f $(TARGET_DIR)/usr/$(GCC_LIB_SUBDIR)/include/syslimits.h ] ; then \
		echo "warning: working around missing syslimits.h" ; \
		cp -f $(STAGING_DIR)/usr/$(GCC_LIB_SUBDIR)/include/syslimits.h \
			$(TARGET_DIR)/usr/$(GCC_LIB_SUBDIR)/include/ ; \
	fi
	# Make sure we have 'cc'.
	if [ ! -e $(TARGET_DIR)/usr/bin/cc ] ; then \
		ln -snf gcc $(TARGET_DIR)/usr/bin/cc ; \
	fi;
	# These are in /lib, so...
	#rm -rf $(TARGET_DIR)/usr/lib/libgcc_s*.so*
	#touch -c $(TARGET_DIR)/usr/bin/gcc

gcc_target: uclibc_target binutils_target $(TARGET_DIR)/usr/bin/gcc

gcc_target-clean:
	rm -rf $(GCC_BUILD_DIR3)
	rm -f $(TARGET_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)*

gcc_target-dirclean:
	rm -rf $(GCC_BUILD_DIR3)

endif
# gcc-3.x only

endif
