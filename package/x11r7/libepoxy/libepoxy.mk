################################################################################
#
# libepoxy
#
################################################################################

LIBEPOXY_VERSION = v1.2
LIBEPOXY_SITE = $(call github,anholt,libepoxy,$(LIBEPOXY_VERSION))
LIBEPOXY_INSTALL_STAGING = YES
LIBEPOXY_AUTORECONF = YES
LIBEPOXY_DEPENDENCIES = mesa3d
LIBEPOXY_LICENSE = MIT
LIBEPOXY_LICENSE_FILES = COPYING

$(eval $(autotools-package))
