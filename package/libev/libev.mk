################################################################################
#
# libev
#
################################################################################

LIBEV_VERSION = 4.15
LIBEV_SITE = http://dist.schmorp.de/libev/
LIBEV_INSTALL_STAGING = YES
LIBEV_LICENSE = BSD-2c or GPLv2+
LIBEV_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
