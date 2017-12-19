################################################################################
#
# liblo
#
################################################################################

LIBLO_VERSION = 0.26
LIBLO_SITE = http://downloads.sourceforge.net/project/liblo/liblo/$(LIBLO_VERSION)

LIBLO_LICENSE = LGPL-2.1+
LIBLO_LICENSE_FILES = COPYING
LIBLO_INSTALL_STAGING = YES

$(eval $(autotools-package))
