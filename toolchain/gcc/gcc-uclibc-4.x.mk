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

ifneq ($(GCC_SNAP_DATE),)
 GCC_SITE:=ftp://sources.redhat.com/pub/gcc/snapshots/$(GCC_VERSION)
else ifeq ($(findstring avr32,$(GCC_VERSION)),avr32)
 GCC_SITE:=ftp://www.at91.com/pub/buildroot/
else
 GCC_SITE:=$(BR2_GNU_MIRROR)/gcc/gcc-$(GCC_VERSION)
endif

ifneq ($(filter xtensa%,$(ARCH)),)
include target/xtensa/patch.in
GCC_PATCH_EXTRA:=$(call XTENSA_PATCH,gcc,$(GCC_PATCH_DIR),. ..)
endif

GCC_SOURCE:=gcc-$(GCC_VERSION).tar.bz2
GCC_PATCH_DIR:=toolchain/gcc/$(GCC_VERSION)
GCC_DIR:=$(TOOLCHAIN_DIR)/gcc-$(GCC_VERSION)
GCC_CAT:=$(BZCAT)
GCC_STRIP_HOST_BINARIES:=nope
GCC_SRC_DIR:=$(GCC_DIR)

# Branding works on >= 4.3
ifneq ($(findstring x4.2.,x$(GCC_VERSION)),x4.2.)
EXTRA_GCC_CONFIG_OPTIONS+=--with-pkgversion="Buildroot $(BR2_VERSION_FULL)" \
	--with-bugurl="http://bugs.buildroot.net/"
endif

# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=43810
# Workaround until it's fixed in 4.5.2 or later
ifeq ($(ARCH),powerpc)
ifeq ($(findstring x4.5.,x$(GCC_VERSION)),x4.5.)
GCC_OPTSPACE=--disable-target-optspace
endif
else
GCC_OPTSPACE=--enable-target-optspace
endif

#############################################################
#
# Setup some initial stuff
#
#############################################################

GCC_STAGING_PREREQ+=$(STAGING_DIR)/usr/lib/libc.a

GCC_TARGET_LANGUAGES:=c

GCC_CROSS_LANGUAGES:=c
ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
GCC_CROSS_LANGUAGES:=$(GCC_CROSS_LANGUAGES),c++
endif
ifeq ($(BR2_GCC_CROSS_FORTRAN),y)
GCC_CROSS_LANGUAGES:=$(GCC_CROSS_LANGUAGES),fortran
endif
ifeq ($(BR2_GCC_CROSS_JAVA),y)
GCC_CROSS_LANGUAGES:=$(GCC_CROSS_LANGUAGES),java
endif
ifeq ($(BR2_GCC_CROSS_OBJC),y)
GCC_CROSS_LANGUAGES:=$(GCC_CROSS_LANGUAGES),objc
endif

GCC_COMMON_PREREQ=$(wildcard $(BR2_DEPENDS_DIR)/br2/install/libstdcpp*)\
$(wildcard $(BR2_DEPENDS_DIR)/br2/install/libgcj*)\
$(wildcard $(BR2_DEPENDS_DIR)/br2/install/objc*)\
$(wildcard $(BR2_DEPENDS_DIR)/br2/install/fortran*)\
$(wildcard $(BR2_DEPENDS_DIR)/br2/prefer/ima*)\
$(wildcard $(BR2_DEPENDS_DIR)/br2/toolchain/sysroot*)\
$(wildcard $(BR2_DEPENDS_DIR)/br2/use/sjlj/exceptions*)\
$(wildcard $(BR2_DEPENDS_DIR)/br2/gcc/shared/libgcc*)
GCC_TARGET_PREREQ+=$(GCC_COMMON_PREREQ) \
$(wildcard $(BR2_DEPENDS_DIR)/br2/extra/target/gcc/config/options*)
GCC_STAGING_PREREQ+=$(GCC_COMMON_PREREQ) \
$(wildcard $(BR2_DEPENDS_DIR)/br2/extra/gcc/config/options*)\
$(wildcard $(BR2_DEPENDS_DIR)/br2/gcc/cross/*)

ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
GCC_TARGET_LANGUAGES:=$(GCC_TARGET_LANGUAGES),c++
endif

ifeq ($(BR2_INSTALL_LIBGCJ),y)
GCC_TARGET_LANGUAGES:=$(GCC_TARGET_LANGUAGES),java
endif

ifeq ($(BR2_INSTALL_OBJC),y)
GCC_TARGET_LANGUAGES:=$(GCC_TARGET_LANGUAGES),objc
endif

ifeq ($(BR2_INSTALL_FORTRAN),y)
GCC_TARGET_LANGUAGES:=$(GCC_TARGET_LANGUAGES),fortran
endif

GCC_WITH_HOST_GMP = --with-gmp=$(HOST_DIR)/usr
GCC_WITH_HOST_MPFR = --with-mpfr=$(HOST_DIR)/usr
ifeq ($(BR2_TOOLCHAIN_BUILDROOT),y)
HOST_SOURCE += host-gmp-source host-mpfr-source
endif
GCC_HOST_PREREQ = host-gmp host-mpfr

ifeq ($(findstring x4.5.,x$(GCC_VERSION)),x4.5.)
GCC_WITH_HOST_MPC = --with-mpc=$(HOST_DIR)/usr
ifeq ($(BR2_TOOLCHAIN_BUILDROOT),y)
HOST_SOURCE += host-mpc-source
endif
GCC_HOST_PREREQ += host-mpc
endif

GCC_TARGET_PREREQ += mpfr gmp
ifeq ($(findstring x4.5.,x$(GCC_VERSION)),x4.5.)
GCC_TARGET_PREREQ += mpc
endif

ifeq ($(BR2_GCC_SHARED_LIBGCC),y)
GCC_SHARED_LIBGCC:=--enable-shared
else
GCC_SHARED_LIBGCC:=--disable-shared
endif

ifeq ($(BR2_GCC_ENABLE_TLS),y)
GCC_TLS:=--enable-tls
else
GCC_TLS:=--disable-tls
endif

ifeq ($(BR2_PTHREADS_NONE),y)
THREADS:=--disable-threads --disable-libgomp
else
THREADS:=--enable-threads
endif

ifeq ($(BR2_GCC_SUPPORTS_FINEGRAINEDMTUNE),y)
GCC_DECIMAL_FLOAT:=--disable-decimal-float
endif

# gcc version < 4.2.0 don't have -Wno-overlength-strings and the configure
# script has problems detecting it, so help it
ifeq ($(shell test $(HOSTCC_VERSION) -lt 420 && echo OLD),OLD)
GCC_CONF_ENV:=acx_cv_prog_cc_pedantic__Wno_long_long__Wno_variadic_macros_____________Wno_overlength_strings=no \
	acx_cv_prog_cc_warning__Wno_overlength_strings=no
endif

ifeq ($(BR2_TOOLCHAIN_BUILDROOT),y)
HOST_SOURCE+=gcc-source
endif

$(DL_DIR)/$(GCC_SOURCE):
	mkdir -p $(DL_DIR)
	$(call DOWNLOAD,$(GCC_SITE),$(GCC_SOURCE))

gcc-unpacked: $(GCC_DIR)/.patched
$(GCC_DIR)/.unpacked: $(DL_DIR)/$(GCC_SOURCE)
	mkdir -p $(TOOLCHAIN_DIR)
	rm -rf $(GCC_DIR)
	$(GCC_CAT) $(DL_DIR)/$(GCC_SOURCE) | tar -C $(TOOLCHAIN_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(@D)
	touch $@

gcc-patched: $(GCC_DIR)/.patched
$(GCC_DIR)/.patched: $(GCC_DIR)/.unpacked
	# Apply any files named gcc-*.patch from the source directory to gcc
ifneq ($(wildcard $(GCC_PATCH_DIR)),)
	toolchain/patch-kernel.sh $(GCC_DIR) $(GCC_PATCH_DIR) \*.patch $(GCC_PATCH_EXTRA)
endif

	# Note: The soft float situation has improved considerably with gcc 3.4.x.
	# We can dispense with the custom spec files, as well as libfloat for the arm case.
	# However, we still need a patch for arm. There's a similar patch for gcc 3.3.x
	# which needs to be integrated so we can kill of libfloat for good, except for
	# anyone (?) who might still be using gcc 2.95. mjn3
ifeq ($(BR2_SOFT_FLOAT),y)
ifeq ("$(strip $(ARCH))","arm")
	toolchain/patch-kernel.sh $(GCC_DIR) toolchain/gcc/$(GCC_VERSION) arm-softfloat.patch.conditional
endif
ifeq ("$(strip $(ARCH))","armeb")
	toolchain/patch-kernel.sh $(GCC_DIR) toolchain/gcc/$(GCC_VERSION) arm-softfloat.patch.conditional
endif
endif
ifeq ($(ARCH)-$(BR2_GCC_SHARED_LIBGCC),powerpc-y)
ifneq ($(BR2_SOFT_FLOAT),)
	toolchain/patch-kernel.sh $(GCC_DIR) toolchain/gcc/$(GCC_VERSION) powerpc-link-with-math-lib.patch.conditional
endif
endif
	touch $@

#############################################################
#
# build the first pass gcc compiler
#
#############################################################
GCC_BUILD_DIR1:=$(TOOLCHAIN_DIR)/gcc-$(GCC_VERSION)-initial

$(GCC_BUILD_DIR1)/.configured: $(GCC_DIR)/.patched
	mkdir -p $(GCC_BUILD_DIR1)
	(cd $(GCC_BUILD_DIR1); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		$(GCC_DIR)/configure $(QUIET) \
		--prefix=$(HOST_DIR)/usr \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_HOST_NAME) \
		--target=$(REAL_GNU_TARGET_NAME) \
		--enable-languages=c \
		$(BR2_CONFIGURE_DEVEL_SYSROOT) \
		--disable-__cxa_atexit \
		$(GCC_OPTSPACE) \
		--with-gnu-ld \
		--disable-shared \
		--disable-libssp \
		--without-headers \
		--with-newlib \
		--disable-multilib \
		$(GCC_TLS) \
		$(GCC_WITH_HOST_GMP) \
		$(GCC_WITH_HOST_MPFR) \
		$(GCC_WITH_HOST_MPC) \
		$(DISABLE_NLS) \
		$(THREADS) \
		$(GCC_DECIMAL_FLOAT) \
		$(SOFT_FLOAT_CONFIG_OPTION) \
		$(GCC_WITH_ABI) $(GCC_WITH_ARCH) $(GCC_WITH_TUNE) $(GCC_WITH_CPU) \
		$(EXTRA_GCC_CONFIG_OPTIONS) \
		$(EXTRA_GCC1_CONFIG_OPTIONS) \
		$(QUIET) \
	)
	touch $@

$(GCC_BUILD_DIR1)/.compiled: $(GCC_BUILD_DIR1)/.configured
ifeq ($(BR2_GCC_SUPPORTS_FINEGRAINEDMTUNE),y)
	$(GCC_CONF_ENV) $(MAKE) -C $(GCC_BUILD_DIR1) all-gcc
else
	$(MAKE) -C $(GCC_BUILD_DIR1) all-gcc
endif
	touch $@

gcc_initial=$(GCC_BUILD_DIR1)/.installed
$(gcc_initial) $(HOST_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)-gcc: $(GCC_BUILD_DIR1)/.compiled
	PATH=$(TARGET_PATH) $(MAKE) -C $(GCC_BUILD_DIR1) install-gcc
	touch $(gcc_initial)

gcc_initial: $(GCC_HOST_PREREQ) host-binutils $(HOST_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)-gcc

gcc_initial-clean:
	rm -rf $(GCC_BUILD_DIR1)

gcc_initial-dirclean:
	rm -rf $(GCC_BUILD_DIR1) $(GCC_DIR)

#############################################################
#
# build the second pass gcc compiler
#
#############################################################
GCC_BUILD_DIR2:=$(TOOLCHAIN_DIR)/gcc-$(GCC_VERSION)-intermediate

# The --without-headers option stopped working with gcc 3.0 and has never been
# fixed, so we need to actually have working C library header files prior to
# the step or libgcc will not build...

$(GCC_BUILD_DIR2)/.configured: $(GCC_DIR)/.patched
	mkdir -p $(GCC_BUILD_DIR2)
	(cd $(GCC_BUILD_DIR2); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		$(GCC_DIR)/configure $(QUIET) \
		--prefix=$(HOST_DIR)/usr \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_HOST_NAME) \
		--target=$(REAL_GNU_TARGET_NAME) \
		--enable-languages=c \
		$(BR2_CONFIGURE_DEVEL_SYSROOT) \
		--disable-__cxa_atexit \
		$(GCC_OPTSPACE) \
		--with-gnu-ld \
		--enable-shared \
		--disable-libssp \
		--disable-multilib \
		$(GCC_TLS) \
		$(GCC_WITH_HOST_GMP) \
		$(GCC_WITH_HOST_MPFR) \
		$(GCC_WITH_HOST_MPC) \
		$(DISABLE_NLS) \
		$(THREADS) \
		$(MULTILIB) \
		$(GCC_DECIMAL_FLOAT) \
		$(SOFT_FLOAT_CONFIG_OPTION) \
		$(GCC_WITH_ABI) $(GCC_WITH_ARCH) $(GCC_WITH_TUNE) $(GCC_WITH_CPU) \
		$(EXTRA_GCC_CONFIG_OPTIONS) \
		$(EXTRA_GCC2_CONFIG_OPTIONS) \
		$(QUIET) \
	)
	touch $@

$(GCC_BUILD_DIR2)/.compiled: $(GCC_BUILD_DIR2)/.configured
	# gcc >= 4.3.0 have to also build all-target-libgcc
ifeq ($(BR2_GCC_SUPPORTS_FINEGRAINEDMTUNE),y)
	$(GCC_CONF_ENV) $(MAKE) -C $(GCC_BUILD_DIR2) all-gcc all-target-libgcc
else
	$(MAKE) -C $(GCC_BUILD_DIR2) all-gcc
endif
	touch $@

gcc_intermediate=$(GCC_BUILD_DIR2)/.installed
$(gcc_intermediate): $(GCC_BUILD_DIR2)/.compiled
	# gcc >= 4.3.0 have to also install install-target-libgcc
ifeq ($(BR2_GCC_SUPPORTS_FINEGRAINEDMTUNE),y)
	PATH=$(TARGET_PATH) $(MAKE) -C $(GCC_BUILD_DIR2) install-gcc install-target-libgcc
else
	PATH=$(TARGET_PATH) $(MAKE) -C $(GCC_BUILD_DIR2) install-gcc
endif
	touch $(gcc_intermediate)

gcc_intermediate: uclibc-configured $(HOST_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)-gcc

gcc_intermediate-clean:
	rm -rf $(GCC_BUILD_DIR2)

gcc_intermediate-dirclean:
	rm -rf $(GCC_BUILD_DIR2) $(GCC_DIR)

#############################################################
#
# third pass compiler build. Build the compiler targeting
# the newly built shared uClibc library.
#
#############################################################
#
# Sigh... I had to rework things because using --with-gxx-include-dir
# causes issues with include dir search order for g++. This seems to
# have something to do with "path translations" and possibly doesn't
# affect gcc-target. However, I haven't tested gcc-target yet so no
# guarantees. mjn3

GCC_BUILD_DIR3:=$(TOOLCHAIN_DIR)/gcc-$(GCC_VERSION)-final
$(GCC_BUILD_DIR3)/.configured: $(GCC_SRC_DIR)/.patched $(GCC_STAGING_PREREQ)
	mkdir -p $(GCC_BUILD_DIR3)
	# Important! Required for limits.h to be fixed.
	ln -snf ../include/ $(HOST_DIR)/usr/$(REAL_GNU_TARGET_NAME)/sys-include
	(cd $(GCC_BUILD_DIR3); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		$(GCC_SRC_DIR)/configure $(QUIET) \
		--prefix=$(HOST_DIR)/usr \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_HOST_NAME) \
		--target=$(REAL_GNU_TARGET_NAME) \
		--enable-languages=$(GCC_CROSS_LANGUAGES) \
		$(BR2_CONFIGURE_STAGING_SYSROOT) \
		$(BR2_CONFIGURE_BUILD_TOOLS) \
		--disable-__cxa_atexit \
		$(GCC_OPTSPACE) \
		--with-gnu-ld \
		--disable-libssp \
		--disable-multilib \
		$(GCC_TLS) \
		$(GCC_SHARED_LIBGCC) \
		$(GCC_WITH_HOST_GMP) \
		$(GCC_WITH_HOST_MPFR) \
		$(GCC_WITH_HOST_MPC) \
		$(DISABLE_NLS) \
		$(THREADS) \
		$(GCC_DECIMAL_FLOAT) \
		$(SOFT_FLOAT_CONFIG_OPTION) \
		$(GCC_WITH_ABI) $(GCC_WITH_ARCH) $(GCC_WITH_TUNE) $(GCC_WITH_CPU) \
		$(DISABLE_LARGEFILE) \
		$(EXTRA_GCC_CONFIG_OPTIONS) \
		$(EXTRA_GCC2_CONFIG_OPTIONS) \
	)
	touch $@

$(GCC_BUILD_DIR3)/.compiled: $(GCC_BUILD_DIR3)/.configured
	$(GCC_CONF_ENV) $(MAKE) -C $(GCC_BUILD_DIR3) all
	touch $@

$(GCC_BUILD_DIR3)/.installed: $(GCC_BUILD_DIR3)/.compiled
	PATH=$(TARGET_PATH) $(MAKE) \
		-C $(GCC_BUILD_DIR3) install
	if [ -d "$(STAGING_DIR)/lib64" ]; then \
		if [ ! -e "$(STAGING_DIR)/lib" ]; then \
			mkdir -p "$(STAGING_DIR)/lib"; \
		fi; \
		mv "$(STAGING_DIR)/lib64/"* "$(STAGING_DIR)/lib/"; \
		rmdir "$(STAGING_DIR)/lib64"; \
		rm "$(STAGING_DIR)/usr/$(REAL_GNU_TARGET_NAME)/lib64";\
	fi
	# Strip the host binaries
ifeq ($(GCC_STRIP_HOST_BINARIES),true)
	strip --strip-all -R .note -R .comment $(filter-out %-gccbug %-embedspu,$(wildcard $(HOST_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)-*))
endif
	# Make sure we have 'cc'.
	if [ ! -e $(HOST_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)-cc ]; then \
		ln -snf $(REAL_GNU_TARGET_NAME)-gcc \
			$(HOST_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)-cc; \
	fi
	if [ ! -e $(HOST_DIR)/usr/$(REAL_GNU_TARGET_NAME)/bin/cc ]; then \
		ln -snf gcc $(HOST_DIR)/usr/$(REAL_GNU_TARGET_NAME)/bin/cc; \
	fi
	# Set up the symlinks to enable lying about target name.
	set -e; \
	(cd $(HOST_DIR)/usr; \
		ln -snf $(REAL_GNU_TARGET_NAME) $(GNU_TARGET_NAME); \
		cd bin; \
		for app in $(REAL_GNU_TARGET_NAME)-*; do \
			ln -snf $${app} \
			$(GNU_TARGET_NAME)$${app##$(REAL_GNU_TARGET_NAME)}; \
		done; \
	)

	mkdir -p $(TARGET_DIR)/usr/lib $(TARGET_DIR)/usr/sbin
	touch $@

$(STAMP_DIR)/gcc_libs_target_installed: $(GCC_BUILD_DIR3)/.installed
ifeq ($(BR2_GCC_SHARED_LIBGCC),y)
	# These go in /lib, so...
	rm -rf $(TARGET_DIR)/usr/lib/libgcc_s*.so*
	-cp -dpf $(HOST_DIR)/usr/$(REAL_GNU_TARGET_NAME)/lib*/libgcc_s* \
		$(STAGING_DIR)/lib/
	-cp -dpf $(HOST_DIR)/usr/$(REAL_GNU_TARGET_NAME)/lib*/libgcc_s* \
		$(TARGET_DIR)/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/lib/libgcc_s*
endif
ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
ifeq ($(BR2_GCC_SHARED_LIBGCC),y)
	mkdir -p $(TARGET_DIR)/usr/lib
	-cp -dpf $(HOST_DIR)/usr/$(REAL_GNU_TARGET_NAME)/lib*/libstdc++.so* \
		$(STAGING_DIR)/usr/lib/
	-cp -dpf $(HOST_DIR)/usr/$(REAL_GNU_TARGET_NAME)/lib*/libstdc++.so* \
		$(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libstdc++.so*
endif
endif
ifeq ($(BR2_INSTALL_LIBGCJ),y)
	cp -dpf $(HOST_DIR)/usr/$(REAL_GNU_TARGET_NAME)/lib*/libgcj.so* $(STAGING_DIR)/usr/lib/
	cp -dpf $(HOST_DIR)/usr/$(REAL_GNU_TARGET_NAME)/lib*/libgcj.so* $(TARGET_DIR)/usr/lib/
	mkdir -p $(STAGING_DIR)/usr/lib/security
	mkdir -p $(TARGET_DIR)/usr/lib/security
	cp -dpf $(HOST_DIR)/usr/lib/security/classpath.security \
		$(STAGING_DIR)/usr/lib/security/
	cp -dpf $(HOST_DIR)/usr/lib/security/classpath.security \
		$(TARGET_DIR)/usr/lib/security/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libgcj.so*
endif
	mkdir -p $(@D)
	touch $@

cross_compiler:=$(HOST_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)-gcc
cross_compiler gcc: gcc_intermediate \
	$(LIBFLOAT_TARGET) uclibc $(GCC_BUILD_DIR3)/.installed \
	$(STAMP_DIR)/gcc_libs_target_installed \
	$(GCC_TARGETS)

gcc-source: $(DL_DIR)/$(GCC_SOURCE)

gcc-clean:
	rm -rf $(GCC_BUILD_DIR3)
	for prog in cpp gcc gcc-[0-9]* protoize unprotoize gcov gccbug cc; do \
		rm -f $(HOST_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)-$$prog; \
		rm -f $(HOST_DIR)/usr/bin/$(GNU_TARGET_NAME)-$$prog; \
	done

gcc-dirclean: gcc_initial-dirclean
	rm -rf $(GCC_BUILD_DIR3)

#############################################################
#
# Next build target gcc compiler
#
#############################################################
GCC_BUILD_DIR4:=$(BUILD_DIR)/gcc-$(GCC_VERSION)-target

$(GCC_BUILD_DIR4)/.prepared: $(STAMP_DIR)/gcc_libs_target_installed
	mkdir -p $(GCC_BUILD_DIR4)
	touch $@

$(GCC_BUILD_DIR4)/.configured: $(GCC_BUILD_DIR4)/.prepared
	(cd $(GCC_BUILD_DIR4); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CFLAGS_FOR_TARGET="$(TARGET_CFLAGS) $(TARGET_SOFT_FLOAT)" \
		CXXFLAGS_FOR_TARGET="$(TARGET_CFLAGS) $(TARGET_SOFT_FLOAT)" \
		CFLAGS="$(TARGET_CFLAGS) $(TARGET_SOFT_FLOAT)" \
		BOOT_CFLAGS="$(TARGET_CFLAGS) $(TARGET_SOFT_FLOAT)" \
		GCC_FOR_TARGET="$(TARGET_CC)" \
		CC_FOR_TARGET="$(TARGET_CC)" \
		CXX_FOR_TARGET="$(TARGET_CXX)" \
		$(GCC_SRC_DIR)/configure $(QUIET) \
		--prefix=/usr \
		--build=$(GNU_HOST_NAME) \
		--host=$(REAL_GNU_TARGET_NAME) \
		--target=$(REAL_GNU_TARGET_NAME) \
		--enable-languages=$(GCC_TARGET_LANGUAGES) \
		--with-gxx-include-dir=/usr/include/c++ \
		--disable-__cxa_atexit \
		--with-gnu-ld \
		--disable-libssp \
		--disable-multilib \
		$(GCC_TLS) \
		$(GCC_SHARED_LIBGCC) \
		$(DISABLE_NLS) \
		$(THREADS) \
		$(GCC_DECIMAL_FLOAT) \
		$(SOFT_FLOAT_CONFIG_OPTION) \
		$(GCC_WITH_ABI) $(GCC_WITH_ARCH) $(GCC_WITH_TUNE) $(GCC_WITH_CPU) \
		$(DISABLE_LARGEFILE) \
		$(EXTRA_GCC_CONFIG_OPTIONS) \
		$(EXTRA_TARGET_GCC_CONFIG_OPTIONS) \
		$(EXTRA_GCC4_CONFIG_OPTIONS) \
	)
	touch $@

$(GCC_BUILD_DIR4)/.compiled: $(GCC_BUILD_DIR4)/.configured
	PATH=$(TARGET_PATH) \
	$(MAKE) -C $(GCC_BUILD_DIR4) all
	touch $@

GCC_LIB_SUBDIR=lib/gcc/$(REAL_GNU_TARGET_NAME)/$(GCC_VERSION)
ifeq ($(findstring x4.2,x$(GCC_VERSION)),x4.2)
GCC_INCLUDE_DIR:=include
else
GCC_INCLUDE_DIR:=include-fixed
endif

$(TARGET_DIR)/usr/bin/gcc: $(GCC_BUILD_DIR4)/.compiled
	PATH=$(TARGET_PATH) DESTDIR=$(TARGET_DIR) \
		$(MAKE1) -C $(GCC_BUILD_DIR4) install
	# Remove broken specs file (cross compile flag is set).
	rm -f $(TARGET_DIR)/usr/$(GCC_LIB_SUBDIR)/specs

	# Remove useless copies of gcc, c++, g++
	rm -f $(TARGET_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)-gcc*
	rm -f $(TARGET_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)-g++*
	rm -f $(TARGET_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)-c++*

	# Work around problem of missing syslimits.h
	if [ ! -f $(TARGET_DIR)/usr/$(GCC_LIB_SUBDIR)/$(GCC_INCLUDE_DIR)/syslimits.h ]; then \
		echo "warning: working around missing syslimits.h"; \
		cp -f $(HOST_DIR)/$(GCC_LIB_SUBDIR)/$(GCC_INCLUDE_DIR)/syslimits.h \
			$(TARGET_DIR)/usr/$(GCC_LIB_SUBDIR)/$(GCC_INCLUDE_DIR)/; \
	fi
	# Make sure we have 'cc'.
	if [ ! -e $(TARGET_DIR)/usr/bin/cc ]; then \
		ln -snf gcc $(TARGET_DIR)/usr/bin/cc; \
	fi
	# These are in /lib, so...
	#rm -rf $(TARGET_DIR)/usr/lib/libgcc_s*.so*
	touch -c $@

gcc_target: $(STAMP_DIR)/gcc_libs_target_installed $(GCC_TARGET_PREREQ) binutils $(TARGET_DIR)/usr/bin/gcc

gcc_target-clean:
	rm -rf $(GCC_BUILD_DIR4)
	rm -f $(TARGET_DIR)/usr/bin/$(REAL_GNU_TARGET_NAME)*

gcc_target-dirclean:
	rm -rf $(GCC_BUILD_DIR4)
