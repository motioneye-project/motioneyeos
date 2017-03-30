################################################################################
#
# libusbgx
#
################################################################################

LIBUSBGX_VERSION = 2e3d43ee098ed928d1baa61ce791ce9ff4788c5a
LIBUSBGX_SITE = $(call github,libusbgx,libusbgx,$(LIBUSBGX_VERSION))
LIBUSBGX_LICENSE = GPL-2.0+ (examples), LGPL-2.1+ (library)
LIBUSBGX_LICENSE_FILES = COPYING COPYING.LGPL
LIBUSBGX_DEPENDENCIES = host-pkgconf libconfig
LIBUSBGX_AUTORECONF = YES
LIBUSBGX_INSTALL_STAGING = YES

$(eval $(autotools-package))
