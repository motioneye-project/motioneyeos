################################################################################
#
# libexif
#
################################################################################

LIBEXIF_VERSION = 0.6.22
LIBEXIF_SOURCE = libexif-$(LIBEXIF_VERSION).tar.xz
LIBEXIF_SITE = \
	https://github.com/libexif/libexif/releases/download/libexif-$(subst .,_,$(LIBEXIF_VERSION))-release
LIBEXIF_INSTALL_STAGING = YES
LIBEXIF_DEPENDENCIES = host-pkgconf
LIBEXIF_LICENSE = LGPL-2.1+
LIBEXIF_LICENSE_FILES = COPYING

$(eval $(autotools-package))
