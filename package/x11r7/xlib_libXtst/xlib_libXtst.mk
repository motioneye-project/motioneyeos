################################################################################
#
# xlib_libXtst -- X.Org Xtst library
#
################################################################################

XLIB_LIBXTST_VERSION = 1.1.0
XLIB_LIBXTST_SOURCE = libXtst-$(XLIB_LIBXTST_VERSION).tar.bz2
XLIB_LIBXTST_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXTST_INSTALL_STAGING = YES

XLIB_LIBXTST_DEPENDENCIES = \
	xlib_libX11 \
	xlib_libXext \
	xlib_libXi \
	xproto_recordproto

$(eval $(autotools-package))
