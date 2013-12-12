################################################################################
#
# parted
#
################################################################################

PARTED_VERSION = 3.1
PARTED_SOURCE = parted-$(PARTED_VERSION).tar.xz
PARTED_SITE = $(BR2_GNU_MIRROR)/parted
PARTED_DEPENDENCIES = readline util-linux
PARTED_INSTALL_STAGING = YES
PARTED_LICENSE = GPLv3+
PARTED_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LVM2),y)
PARTED_DEPENDENCIES += lvm2
PARTED_CONF_OPT += --enable-device-mapper
else
PARTED_CONF_OPT += --disable-device-mapper
endif

$(eval $(autotools-package))
