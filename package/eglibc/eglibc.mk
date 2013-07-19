################################################################################
#
# eglibc
#
################################################################################

EGLIBC_VERSION = 2.17-svnr22064
EGLIBC_SITE = http://downloads.yoctoproject.org/releases/eglibc/
EGLIBC_SOURCE = eglibc-$(EGLIBC_VERSION).tar.bz2
EGLIBC_LICENSE = GPLv2+ (programs), LGPLv2.1+, BSD-3c, MIT (library)
EGLIBC_LICENSE_FILES = libc/COPYING libc/COPYING.LIB libc/LICENSES

# Before eglibc is configured, we must have the first stage
# cross-compiler and the kernel headers
EGLIBC_DEPENDENCIES = host-gcc-initial linux-headers host-gawk

# Before eglibc is built, we must have the second stage cross-compiler
eglibc-build: host-gcc-intermediate

EGLIBC_SUBDIR = build

EGLIBC_INSTALL_STAGING = YES

EGLIBC_INSTALL_STAGING_OPT = install_root=$(STAGING_DIR) install

# Thumb build is broken, build in ARM mode
ifeq ($(BR2_ARM_INSTRUCTIONS_THUMB),y)
EGLIBC_EXTRA_CFLAGS += -marm
endif

# Even though we use the autotools-package infrastructure, we have to
# override the default configure commands for several reasons:
#
#  1. We have to build out-of-tree, but we can't use the same
#     'symbolic link to configure' used with the gcc packages.
#
#  2. We have to execute the configure script with bash and not sh.
#
define EGLIBC_CONFIGURE_CMDS
	mkdir -p $(@D)/build
	# Do the configuration
	(cd $(@D)/build; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="-O2 $(EGLIBC_EXTRA_CFLAGS)" CPPFLAGS="" \
		CXXFLAGS="-O2 $(EGLIBC_EXTRA_CFLAGS)" \
		$(SHELL) $(@D)/libc/configure \
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

EGLIBC_LIBS_LIB = \
	ld*.so libc.so libcrypt.so libdl.so libgcc_s.so libm.so	   \
	libnsl.so libpthread.so libresolv.so librt.so libutil.so   \
	libnss_files.so libnss_dns.so

ifeq ($(BR2_PACKAGE_GDB_SERVER),y)
EGLIBC_LIBS_LIB += libthread_db.so
endif

ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
EGLIBC_LIBS_USR_LIB += libstdc++.so
endif

define EGLIBC_INSTALL_TARGET_CMDS
	for libs in $(EGLIBC_LIBS_LIB); do \
		$(call copy_toolchain_lib_root,$(STAGING_DIR)/,,lib,$$libs,/lib) ; \
	done
	for libs in $(EGLIBC_LIBS_USR_LIB); do \
		$(call copy_toolchain_lib_root,$(STAGING_DIR)/,,lib,$$libs,/usr/lib) ; \
	done
endef

$(eval $(autotools-package))
