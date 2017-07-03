################################################################################
#
# binutils
#
################################################################################

# Version is set when using buildroot toolchain.
# If not, we do like other packages
BINUTILS_VERSION = $(call qstrip,$(BR2_BINUTILS_VERSION))
ifeq ($(BINUTILS_VERSION),)
ifeq ($(BR2_arc),y)
BINUTILS_VERSION = arc-2017.03
else
BINUTILS_VERSION = 2.27
endif
endif # BINUTILS_VERSION

ifeq ($(BR2_arc),y)
BINUTILS_SITE = $(call github,foss-for-synopsys-dwc-arc-processors,binutils-gdb,$(BINUTILS_VERSION))
BINUTILS_SOURCE = binutils-$(BINUTILS_VERSION).tar.gz
BINUTILS_FROM_GIT = y
endif
BINUTILS_SITE ?= $(BR2_GNU_MIRROR)/binutils
BINUTILS_SOURCE ?= binutils-$(BINUTILS_VERSION).tar.bz2
BINUTILS_EXTRA_CONFIG_OPTIONS = $(call qstrip,$(BR2_BINUTILS_EXTRA_CONFIG_OPTIONS))
BINUTILS_INSTALL_STAGING = YES
BINUTILS_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)
BINUTILS_MAKE_OPTS = LIBS=$(TARGET_NLS_LIBS)
BINUTILS_LICENSE = GPL-3.0+, libiberty LGPL-2.1+
BINUTILS_LICENSE_FILES = COPYING3 COPYING.LIB

ifeq ($(BINUTILS_FROM_GIT),y)
BINUTILS_DEPENDENCIES += host-flex host-bison
HOST_BINUTILS_DEPENDENCIES += host-flex host-bison
endif

# When binutils sources are fetched from the binutils-gdb repository,
# they also contain the gdb sources, but gdb shouldn't be built, so we
# disable it.
BINUTILS_DISABLE_GDB_CONF_OPTS = \
	--disable-sim \
	--disable-gdb

# We need to specify host & target to avoid breaking ARM EABI
BINUTILS_CONF_OPTS = \
	--disable-multilib \
	--disable-werror \
	--host=$(GNU_TARGET_NAME) \
	--target=$(GNU_TARGET_NAME) \
	--enable-install-libiberty \
	--enable-build-warnings=no \
	$(BINUTILS_DISABLE_GDB_CONF_OPTS) \
	$(BINUTILS_EXTRA_CONFIG_OPTIONS)

ifeq ($(BR2_STATIC_LIBS),y)
BINUTILS_CONF_OPTS += --disable-plugins
endif

# Don't build documentation. It takes up extra space / build time,
# and sometimes needs specific makeinfo versions to work
BINUTILS_CONF_ENV += MAKEINFO=true
BINUTILS_MAKE_OPTS += MAKEINFO=true
BINUTILS_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) MAKEINFO=true install
HOST_BINUTILS_CONF_ENV += MAKEINFO=true
HOST_BINUTILS_MAKE_OPTS += MAKEINFO=true
HOST_BINUTILS_INSTALL_OPTS += MAKEINFO=true install

# gcc bug with Os/O1/O2/O3, PR77311
# error: unable to find a register to spill in class 'CCREGS'
ifeq ($(BR2_bfin),y)
BINUTILS_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -O0"
endif

# Workaround a build issue with -Os for ARM Cortex-M cpus.
# (Binutils 2.25.1 and 2.26.1)
# https://sourceware.org/bugzilla/show_bug.cgi?id=20552
ifeq ($(BR2_ARM_CPU_ARMV7M)$(BR2_OPTIMIZE_S),yy)
BINUTILS_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -O2"
endif

# Install binutils after busybox to prefer full-blown utilities
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
BINUTILS_DEPENDENCIES += busybox
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
BINUTILS_DEPENDENCIES += zlib
endif

# "host" binutils should actually be "cross"
# We just keep the convention of "host utility" for now
HOST_BINUTILS_CONF_OPTS = \
	--disable-multilib \
	--disable-werror \
	--target=$(GNU_TARGET_NAME) \
	--disable-shared \
	--enable-static \
	--with-sysroot=$(STAGING_DIR) \
	--enable-poison-system-directories \
	$(BINUTILS_DISABLE_GDB_CONF_OPTS) \
	$(BINUTILS_EXTRA_CONFIG_OPTIONS)

# binutils run configure script of subdirs at make time, so ensure
# our TARGET_CONFIGURE_ARGS are taken into consideration for those
define BINUTILS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_ARGS) $(MAKE) $(BINUTILS_MAKE_OPTS) -C $(@D)
endef

# We just want libbfd, libiberty and libopcodes,
# not the full-blown binutils in staging
define BINUTILS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/bfd DESTDIR=$(STAGING_DIR) install
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/opcodes DESTDIR=$(STAGING_DIR) install
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/libiberty DESTDIR=$(STAGING_DIR) install
endef

# If we don't want full binutils on target
ifneq ($(BR2_PACKAGE_BINUTILS_TARGET),y)
define BINUTILS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/bfd DESTDIR=$(TARGET_DIR) install
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/libiberty DESTDIR=$(STAGING_DIR) install
endef
endif

ifneq ($(ARCH_XTENSA_CORE_NAME),)
define BINUTILS_XTENSA_OVERLAY_EXTRACT
	$(call arch-xtensa-overlay-extract,$(@D),binutils)
endef
BINUTILS_POST_EXTRACT_HOOKS += BINUTILS_XTENSA_OVERLAY_EXTRACT
HOST_BINUTILS_POST_EXTRACT_HOOKS += BINUTILS_XTENSA_OVERLAY_EXTRACT
endif

ifeq ($(BR2_BINUTILS_ENABLE_LTO),y)
HOST_BINUTILS_CONF_OPTS += --enable-plugins --enable-lto
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
