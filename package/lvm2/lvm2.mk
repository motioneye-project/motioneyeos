################################################################################
#
# lvm2
#
################################################################################

LVM2_VERSION = 2.02.185
LVM2_SOURCE = LVM2.$(LVM2_VERSION).tgz
LVM2_SITE = ftp://sources.redhat.com/pub/lvm2
LVM2_INSTALL_STAGING = YES
LVM2_LICENSE = GPL-2.0, LGPL-2.1
LVM2_LICENSE_FILES = COPYING COPYING.LIB

# Make sure that binaries and libraries are installed with write
# permissions for the owner. We disable NLS because it's broken, and
# the package anyway doesn't provide any translation files.
LVM2_CONF_OPTS += \
	--enable-write_install \
	--enable-pkgconfig \
	--enable-cmdlib \
	--enable-dmeventd \
	--disable-nls \
	--disable-symvers

LVM2_DEPENDENCIES += host-pkgconf libaio

# LVM2 uses autoconf, but not automake, and the build system does not
# take into account the toolchain passed at configure time.
LVM2_MAKE_ENV = $(TARGET_CONFIGURE_OPTS)

# package/readline is GPL-3.0+, so not license compatible
LVM2_CONF_OPTS += --disable-readline

LVM2_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR)
LVM2_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR)

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
LVM2_CONF_OPTS += --enable-udev_rules
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
LVM2_CONF_OPTS += --enable-selinux
LVM2_DEPENDENCIES += libselinux
else
LVM2_CONF_OPTS += --disable-selinux
endif

ifeq ($(BR2_PACKAGE_LVM2_STANDARD_INSTALL),)
LVM2_MAKE_OPTS = device-mapper
LVM2_INSTALL_STAGING_OPTS += install_device-mapper
LVM2_INSTALL_TARGET_OPTS += install_device-mapper
else
LVM2_INSTALL_STAGING_OPTS += install
LVM2_INSTALL_TARGET_OPTS += install
endif

ifeq ($(BR2_PACKAGE_LVM2_APP_LIBRARY),y)
LVM2_CONF_OPTS += --enable-applib
else
LVM2_CONF_OPTS += --disable-applib
endif

ifeq ($(BR2_PACKAGE_LVM2_LVMETAD),y)
LVM2_CONF_OPTS += --enable-lvmetad
else
LVM2_CONF_OPTS += --disable-lvmetad
endif

ifeq ($(BR2_INIT_SYSTEMD),y)
LVM2_INSTALL_TARGET_OPTS += install_systemd_units install_systemd_generators
endif

ifeq ($(BR2_TOOLCHAIN_SUPPORTS_PIE),)
LVM2_CONF_ENV += ac_cv_flag_HAVE_PIE=no
endif

HOST_LVM2_DEPENDENCIES = host-pkgconf host-libaio
HOST_LVM2_CONF_OPTS = \
	--enable-write_install \
	--enable-pkgconfig \
	--disable-cmdlib \
	--disable-dmeventd \
	--disable-applib \
	--disable-fsadm \
	--disable-readline \
	--disable-selinux
HOST_LVM2_MAKE_OPTS = device-mapper
HOST_LVM2_INSTALL_OPTS = install_device-mapper

$(eval $(autotools-package))
$(eval $(host-autotools-package))
