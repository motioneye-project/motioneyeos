################################################################################
#
# libmms
#
################################################################################

LIBMMS_VERSION = 0.6.2
LIBMMS_SITE = http://downloads.sourceforge.net/project/libmms/libmms/$(LIBMMS_VERSION)
LIBMMS_INSTALL_STAGING = YES
LIBMMS_DEPENDENCIES = host-pkgconf libglib2
LIBMMS_LICENSE = LGPLv2.1+
LIBMMS_LICENSE_FILES = COPYING.LIB

$(eval $(autotools-package))
