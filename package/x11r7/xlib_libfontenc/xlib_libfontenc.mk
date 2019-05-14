################################################################################
#
# xlib_libfontenc
#
################################################################################

XLIB_LIBFONTENC_VERSION = 1.1.3
XLIB_LIBFONTENC_SOURCE = libfontenc-$(XLIB_LIBFONTENC_VERSION).tar.bz2
XLIB_LIBFONTENC_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBFONTENC_LICENSE = MIT
XLIB_LIBFONTENC_LICENSE_FILES = COPYING
XLIB_LIBFONTENC_INSTALL_STAGING = YES
XLIB_LIBFONTENC_DEPENDENCIES = zlib xorgproto host-pkgconf
HOST_XLIB_LIBFONTENC_DEPENDENCIES = host-zlib host-xorgproto host-pkgconf

$(eval $(autotools-package))
$(eval $(host-autotools-package))
