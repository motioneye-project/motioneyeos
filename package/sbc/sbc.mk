################################################################################
#
# sbc
#
################################################################################

SBC_VERSION = 1.3
SBC_SOURCE = sbc-$(SBC_VERSION).tar.xz
SBC_SITE = $(BR2_KERNEL_MIRROR)/linux/bluetooth
SBC_INSTALL_STAGING = YES
SBC_DEPENDENCIES = libsndfile host-pkgconf
SBC_LICENSE = GPL-2.0+ (programs), LGPL-2.1+ (library)
SBC_LICENSE_FILES = COPYING COPYING.LIB

$(eval $(autotools-package))
