################################################################################
#
# libdvdread
#
################################################################################

LIBDVDREAD_VERSION = 5.0.3
LIBDVDREAD_SOURCE = libdvdread-$(LIBDVDREAD_VERSION).tar.bz2
LIBDVDREAD_SITE = http://www.videolan.org/pub/videolan/libdvdread/$(LIBDVDREAD_VERSION)
LIBDVDREAD_INSTALL_STAGING = YES
LIBDVDREAD_LICENSE = GPLv2+
LIBDVDREAD_LICENSE_FILES = COPYING

$(eval $(autotools-package))
