################################################################################
#
# libmms
#
################################################################################

LIBMMS_VERSION = 0.6.4
LIBMMS_SITE = http://downloads.sourceforge.net/project/libmms/libmms/$(LIBMMS_VERSION)
LIBMMS_INSTALL_STAGING = YES
LIBMMS_DEPENDENCIES = host-pkgconf libglib2
LIBMMS_LICENSE = LGPL-2.1+
LIBMMS_LICENSE_FILES = COPYING.LIB

$(eval $(autotools-package))
