################################################################################
#
# libtool
#
################################################################################

LIBTOOL_VERSION = 2.4.2
LIBTOOL_SOURCE = libtool-$(LIBTOOL_VERSION).tar.gz
LIBTOOL_SITE = $(BR2_GNU_MIRROR)/libtool
LIBTOOL_INSTALL_STAGING = YES
LIBTOOL_LICENSE = GPLv2+
LIBTOOL_LICENSE_FILES = COPYING

HOST_LIBTOOL_LIBTOOL_PATCH = NO

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# variables used by other packages
LIBTOOL = $(HOST_DIR)/usr/bin/libtool
LIBTOOLIZE = $(HOST_DIR)/usr/bin/libtoolize
