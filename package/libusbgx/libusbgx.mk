################################################################################
#
# libusbgx
#
################################################################################

LIBUSBGX_VERSION = libusbgx-v0.2.0
LIBUSBGX_SITE = $(call github,libusbgx,libusbgx,$(LIBUSBGX_VERSION))
LIBUSBGX_LICENSE = GPL-2.0+ (examples), LGPL-2.1+ (library)
LIBUSBGX_LICENSE_FILES = COPYING COPYING.LGPL
LIBUSBGX_DEPENDENCIES = host-pkgconf libconfig
LIBUSBGX_AUTORECONF = YES
LIBUSBGX_INSTALL_STAGING = YES

$(eval $(autotools-package))
