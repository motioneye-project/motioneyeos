#############################################################
#
# binutils
#
#############################################################

# Version is set when using buildroot toolchain.
# If not, we do like other packages
BINUTILS_VERSION = $(call qstrip,$(BR2_BINUTILS_VERSION))
ifeq ($(BINUTILS_VERSION),)
ifeq ($(BR2_avr32),y)
# avr32 uses a special version
BINUTILS_VERSION = 2.18-avr32-1.0.1
else
BINUTILS_VERSION = 2.21
endif
endif

BINUTILS_SOURCE = binutils-$(BINUTILS_VERSION).tar.bz2
BINUTILS_SITE = $(BR2_GNU_MIRROR)/binutils
ifeq ($(ARCH),avr32)
BINUTILS_SITE = ftp://www.at91.com/pub/buildroot
endif
BINUTILS_EXTRA_CONFIG_OPTIONS = $(call qstrip,$(BR2_BINUTILS_EXTRA_CONFIG_OPTIONS))
BINUTILS_INSTALL_STAGING = YES
BINUTILS_DEPENDENCIES = $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext libintl)

# We need to specify host & target to avoid breaking ARM EABI
BINUTILS_CONF_OPT = --disable-multilib --disable-werror \
		--host=$(GNU_TARGET_NAME) \
		--target=$(GNU_TARGET_NAME) \
		--enable-shared \
		$(BINUTILS_EXTRA_CONFIG_OPTIONS)

# Install binutils after busybox to prefer full-blown utilities
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
BINUTILS_DEPENDENCIES += busybox
endif

# "host" binutils should actually be "cross"
# We just keep the convention of "host utility" for now
HOST_BINUTILS_CONF_OPT = --disable-multilib --disable-werror \
			--target=$(GNU_TARGET_NAME) \
			--disable-shared --enable-static \
			--with-sysroot=$(STAGING_DIR) \
			$(BINUTILS_EXTRA_CONFIG_OPTIONS)

HOST_BINUTILS_DEPENDENCIES =

# We just want libbfd and libiberty, not the full-blown binutils in staging
define BINUTILS_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D)/bfd DESTDIR=$(STAGING_DIR) install
	$(MAKE) -C $(@D)/libiberty DESTDIR=$(STAGING_DIR) install
endef

# If we don't want full binutils on target
ifneq ($(BR2_PACKAGE_BINUTILS_TARGET),y)
define BINUTILS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/bfd DESTDIR=$(TARGET_DIR) install
	$(MAKE) -C $(@D)/libiberty DESTDIR=$(STAGING_DIR) install
endef
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
