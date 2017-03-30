################################################################################
#
# libmbus
#
################################################################################

LIBMBUS_VERSION = 0.8.0
LIBMBUS_SITE = http://www.rscada.se/public-dist
LIBMBUS_INSTALL_STAGING = YES
LIBMBUS_LICENSE = BSD-3-Clause
LIBMBUS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
