################################################################################
#
# glibc/eglibc
#
################################################################################

ifeq ($(BR2_TOOLCHAIN_BUILDROOT_EGLIBC),y)
GLIBC_VERSION = 2.17-svnr22064
GLIBC_SITE = http://downloads.yoctoproject.org/releases/eglibc/
GLIBC_SOURCE = eglibc-$(GLIBC_VERSION).tar.bz2
GLIBC_SRC_SUBDIR = libc
else
GLIBC_VERSION = 2.18
GLIBC_SITE = $(BR2_GNU_MIRROR)/libc
GLIBC_SOURCE = glibc-$(GLIBC_VERSION).tar.xz
GLIBC_SRC_SUBDIR = .
endif

GLIBC_LICENSE = GPLv2+ (programs), LGPLv2.1+, BSD-3c, MIT (library)
GLIBC_LICENSE_FILES = $(addprefix $(GLIBC_SRC_SUBDIR)/,COPYING COPYING.LIB LICENSES)

# Before (e)glibc is configured, we must have the first stage
# cross-compiler and the kernel headers
GLIBC_DEPENDENCIES = host-gcc-initial linux-headers

# eglibc also needs host-gawk
ifeq ($(BR2_TOOLCHAIN_BUILDROOT_EGLIBC),y)
GLIBC_DEPENDENCIES += host-gawk
endif

# Before (e)glibc is built, we must have the second stage
# cross-compiler, for some gcc versions
glibc-build: $(if $(BR2_TOOLCHAIN_NEEDS_THREE_STAGE_BUILD),host-gcc-intermediate)

GLIBC_SUBDIR = build

GLIBC_INSTALL_STAGING = YES

GLIBC_INSTALL_STAGING_OPT = install_root=$(STAGING_DIR) install

# Thumb build is broken, build in ARM mode
ifeq ($(BR2_ARM_INSTRUCTIONS_THUMB),y)
GLIBC_EXTRA_CFLAGS += -marm
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
# http://patches.openembedded.org/patch/38849/, eglibc/glibc must be
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
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--enable-shared \
		$(if $(BR2_SOFT_FLOAT),--without-fp,--with-fp) \
		--with-pkgversion="Buildroot" \
		--without-cvs \
		--disable-profile \
		--without-gd \
		--enable-obsolete-rpc \
		--with-headers=$(STAGING_DIR)/usr/include)
	# Install headers and start files
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/build \
		install_root=$(STAGING_DIR) \
		install-bootstrap-headers=yes \
		install-headers
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/build csu/subdir_lib
	cp $(@D)/build/csu/crt1.o $(STAGING_DIR)/usr/lib/
	cp $(@D)/build/csu/crti.o $(STAGING_DIR)/usr/lib/
	cp $(@D)/build/csu/crtn.o $(STAGING_DIR)/usr/lib/
	$(TARGET_CROSS)gcc -nostdlib \
		-nostartfiles -shared -x c /dev/null -o $(STAGING_DIR)/usr/lib/libc.so
endef


#
# We also override the install to target commands since we only want
# to install the libraries, and nothing more.
#

GLIBC_LIBS_LIB = \
	ld*.so libc.so libcrypt.so libdl.so libgcc_s.so libm.so	   \
	libnsl.so libpthread.so libresolv.so librt.so libutil.so   \
	libnss_files.so libnss_dns.so

ifeq ($(BR2_PACKAGE_GDB_SERVER),y)
GLIBC_LIBS_LIB += libthread_db.so
endif

define GLIBC_INSTALL_TARGET_CMDS
	for libs in $(GLIBC_LIBS_LIB); do \
		$(call copy_toolchain_lib_root,$(STAGING_DIR)/,,lib,$$libs,/lib) ; \
	done
endef

$(eval $(autotools-package))
