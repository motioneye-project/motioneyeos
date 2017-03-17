################################################################################
#
# glibc
#
################################################################################

GLIBC_VERSION = $(call qstrip,$(BR2_GLIBC_VERSION_STRING))
GLIBC_SITE = $(BR2_GNU_MIRROR)/libc
GLIBC_SOURCE = glibc-$(GLIBC_VERSION).tar.xz
GLIBC_SRC_SUBDIR = .

GLIBC_LICENSE = GPLv2+ (programs), LGPLv2.1+, BSD-3c, MIT (library)
GLIBC_LICENSE_FILES = $(addprefix $(GLIBC_SRC_SUBDIR)/,COPYING COPYING.LIB LICENSES)

# glibc is part of the toolchain so disable the toolchain dependency
GLIBC_ADD_TOOLCHAIN_DEPENDENCY = NO

# Before glibc is configured, we must have the first stage
# cross-compiler and the kernel headers
GLIBC_DEPENDENCIES = host-gcc-initial linux-headers host-gawk

GLIBC_SUBDIR = build

GLIBC_INSTALL_STAGING = YES

GLIBC_INSTALL_STAGING_OPTS = install_root=$(STAGING_DIR) install

# Thumb build is broken, build in ARM mode
ifeq ($(BR2_ARM_INSTRUCTIONS_THUMB),y)
GLIBC_EXTRA_CFLAGS += -marm
endif

# MIPS64 defaults to n32 so pass the correct -mabi if
# we are using a different ABI. OABI32 is also used
# in MIPS so we pass -mabi=32 in this case as well
# even though it's not strictly necessary.
ifeq ($(BR2_MIPS_NABI64),y)
GLIBC_EXTRA_CFLAGS += -mabi=64
else ifeq ($(BR2_MIPS_OABI32),y)
GLIBC_EXTRA_CFLAGS += -mabi=32
endif

ifeq ($(BR2_ENABLE_DEBUG),y)
GLIBC_EXTRA_CFLAGS += -g
endif

# The stubs.h header is not installed by install-headers, but is
# needed for the gcc build. An empty stubs.h will work, as explained
# in http://gcc.gnu.org/ml/gcc/2002-01/msg00900.html. The same trick
# is used by Crosstool-NG.
ifeq ($(BR2_TOOLCHAIN_BUILDROOT_GLIBC),y)
define GLIBC_ADD_MISSING_STUB_H
	mkdir -p $(STAGING_DIR)/usr/include/gnu
	touch $(STAGING_DIR)/usr/include/gnu/stubs.h
endef
endif

# Even though we use the autotools-package infrastructure, we have to
# override the default configure commands for several reasons:
#
#  1. We have to build out-of-tree, but we can't use the same
#     'symbolic link to configure' used with the gcc packages.
#
#  2. We have to execute the configure script with bash and not sh.
#
# Note that as mentionned in
# http://patches.openembedded.org/patch/38849/, glibc must be
# built with -O2, so we pass our own CFLAGS and CXXFLAGS below.
define GLIBC_CONFIGURE_CMDS
	mkdir -p $(@D)/build
	# Do the configuration
	(cd $(@D)/build; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="-O2 $(GLIBC_EXTRA_CFLAGS)" CPPFLAGS="" \
		CXXFLAGS="-O2 $(GLIBC_EXTRA_CFLAGS)" \
		$(SHELL) $(@D)/$(GLIBC_SRC_SUBDIR)/configure \
		ac_cv_path_BASH_SHELL=/bin/bash \
		libc_cv_forced_unwind=yes \
		libc_cv_ssp=no \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--enable-shared \
		$(if $(BR2_SOFT_FLOAT),--without-fp,--with-fp) \
		$(if $(BR2_x86_64),--enable-lock-elision) \
		--with-pkgversion="Buildroot" \
		--without-cvs \
		--disable-profile \
		--without-gd \
		--enable-obsolete-rpc \
		--enable-kernel=$(call qstrip,$(BR2_TOOLCHAIN_HEADERS_AT_LEAST)) \
		--with-headers=$(STAGING_DIR)/usr/include)
	$(GLIBC_ADD_MISSING_STUB_H)
endef


#
# We also override the install to target commands since we only want
# to install the libraries, and nothing more.
#

GLIBC_LIBS_LIB = \
	ld*.so.* libanl.so.* libc.so.* libcrypt.so.* libdl.so.* libgcc_s.so.* \
	libm.so.* libnsl.so.* libpthread.so.* libresolv.so.* librt.so.* \
	libutil.so.* libnss_files.so.* libnss_dns.so.* libmvec.so.*

ifeq ($(BR2_PACKAGE_GDB),y)
GLIBC_LIBS_LIB += libthread_db.so.*
endif

define GLIBC_INSTALL_TARGET_CMDS
	for libs in $(GLIBC_LIBS_LIB); do \
		$(call copy_toolchain_lib_root,$$libs) ; \
	done
endef

# MIPS R6 requires to have NaN2008 support which is currently not
# supported by the Linux kernel. In order to prevent building the
# glibc against kernels not having NaN2008 support on platforms that
# requires it, glibc currently checks for an (inexisting) 10.0.0
# kernel headers version.
#
# Since in practice the kernel support for NaN2008 is not really
# required for things to work properly, we adjust the glibc check to
# make it believe that NaN2008 support was added in the kernel
# starting from version 4.0.0.
#
# In general the compatibility issues introduced by mis-matched NaN
# encodings will not cause a problem as signalling NaNs are rarely used
# in average code. For MIPS R6 there isn't actually any compatibility
# issue as the hardware is always NaN2008 and software is always
# NaN2008. The problem only comes from when older MIPS code is linked in
# via a DSO and multiple NaN encodings are introduced. Since Buildroot
# is intended to have all code built from source then this scenario is
# highly unlikely. The failure mode, if it ever occurs, would be either
# that a signalling NaN fails to raise an invalid operation exception or
# (more likely) an ordinary NaN raises an invalid operation exception.
ifeq ($(BR2_MIPS_CPU_MIPS32R6)$(BR2_MIPS_CPU_MIPS64R6),y)
define GLIBC_FIX_MIPS_R6
	$(SED) 's#10.0.0#4.0.0#' \
		$(@D)/sysdeps/unix/sysv/linux/mips/configure \
		$(@D)/sysdeps/unix/sysv/linux/mips/configure.ac
endef
GLIBC_POST_EXTRACT_HOOKS += GLIBC_FIX_MIPS_R6
endif

$(eval $(autotools-package))
