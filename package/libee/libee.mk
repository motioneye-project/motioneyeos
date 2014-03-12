################################################################################
#
# libee
#
################################################################################

LIBEE_VERSION = 0.4.1
LIBEE_SITE = http://www.libee.org/download/files/download/
LIBEE_LICENSE = LGPLv2.1+
LIBEE_LICENSE_FILES = COPYING
LIBEE_DEPENDENCIES = libestr host-pkgconf
LIBEE_INSTALL_STAGING = YES

LIBEE_MAKE = $(MAKE1)

$(eval $(autotools-package))
