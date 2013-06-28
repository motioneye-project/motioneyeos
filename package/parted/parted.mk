################################################################################
#
# parted
#
################################################################################

PARTED_VERSION = 3.1
PARTED_SOURCE = parted-$(PARTED_VERSION).tar.xz
PARTED_SITE = $(BR2_GNU_MIRROR)/parted
PARTED_DEPENDENCIES = readline util-linux lvm2
PARTED_INSTALL_STAGING = YES
PARTED_LICENSE = GPLv3+
PARTED_LICENSE_FILES = COPYING

$(eval $(autotools-package))
