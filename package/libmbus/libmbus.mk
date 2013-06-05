################################################################################
#
# libmbus
#
################################################################################

LIBMBUS_VERSION = 0.8.0
LIBMBUS_SITE = http://www.freescada.com/public-dist
LIBMBUS_INSTALL_STAGING = YES

$(eval $(autotools-package))
