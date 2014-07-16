################################################################################
#
# parted
#
################################################################################

PARTED_VERSION = 3.1
PARTED_SOURCE = parted-$(PARTED_VERSION).tar.xz
PARTED_SITE = $(BR2_GNU_MIRROR)/parted
PARTED_DEPENDENCIES = util-linux
PARTED_INSTALL_STAGING = YES
# For uclinux patch
PARTED_AUTORECONF = YES
PARTED_GETTEXTIZE = YES
PARTED_LICENSE = GPLv3+
PARTED_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_READLINE),y)
PARTED_DEPENDENCIES += readline
PARTED_CONF_OPT += --with-readline
else
PARTED_CONF_OPT += --without-readline
endif

ifeq ($(BR2_PACKAGE_LVM2),y)
PARTED_DEPENDENCIES += lvm2
PARTED_CONF_OPT += --enable-device-mapper
else
PARTED_CONF_OPT += --disable-device-mapper
endif

ifeq ($(BR2_PREFER_STATIC_LIB),y)
PARTED_CONF_OPT += --disable-dynamic-loading
endif

HOST_PARTED_DEPENDENCIES = host-util-linux
HOST_PARTED_CONF_OPT += \
	--without-readline \
	--disable-device-mapper \

$(eval $(autotools-package))
$(eval $(host-autotools-package))
