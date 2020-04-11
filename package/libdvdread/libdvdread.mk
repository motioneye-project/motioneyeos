################################################################################
#
# libdvdread
#
################################################################################

LIBDVDREAD_VERSION = 6.1.1
LIBDVDREAD_SOURCE = libdvdread-$(LIBDVDREAD_VERSION).tar.bz2
LIBDVDREAD_SITE = http://www.videolan.org/pub/videolan/libdvdread/$(LIBDVDREAD_VERSION)
LIBDVDREAD_INSTALL_STAGING = YES
LIBDVDREAD_LICENSE = GPL-2.0+
LIBDVDREAD_LICENSE_FILES = COPYING
LIBDVDREAD_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -std=gnu99"
LIBDVDREAD_CONF_OPTS = --with-libdvdcss
LIBDVDREAD_DEPENDENCIES = libdvdcss host-pkgconf

$(eval $(autotools-package))
