################################################################################
#
# xlib_libfontenc -- X.Org fontenc library
#
################################################################################

XLIB_LIBFONTENC_VERSION = 1.0.5
XLIB_LIBFONTENC_SOURCE = libfontenc-$(XLIB_LIBFONTENC_VERSION).tar.bz2
XLIB_LIBFONTENC_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBFONTENC_INSTALL_STAGING = YES
XLIB_LIBFONTENC_DEPENDENCIES = zlib xproto_xproto

$(eval $(autotools-package))
$(eval $(host-autotools-package))
