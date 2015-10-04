################################################################################
#
# xlib_libXtst
#
################################################################################

XLIB_LIBXTST_VERSION = 1.2.2
XLIB_LIBXTST_SOURCE = libXtst-$(XLIB_LIBXTST_VERSION).tar.bz2
XLIB_LIBXTST_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXTST_LICENSE = MIT
XLIB_LIBXTST_LICENSE_FILES = COPYING
XLIB_LIBXTST_INSTALL_STAGING = YES

XLIB_LIBXTST_DEPENDENCIES = \
	xlib_libX11 \
	xlib_libXext \
	xlib_libXi \
	xproto_recordproto

$(eval $(autotools-package))
