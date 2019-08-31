################################################################################
#
# libndp
#
################################################################################

LIBNDP_VERSION = 1.7
LIBNDP_SITE = $(call github,jpirko,libndp,v$(LIBNDP_VERSION))
LIBNDP_LICENSE = LGPL-2.1+
LIBNDP_LICENSE_FILES = COPYING
LIBNDP_AUTORECONF = YES
LIBNDP_INSTALL_STAGING = YES

$(eval $(autotools-package))
