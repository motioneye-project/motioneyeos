################################################################################
#
# xlib_libXaw
#
################################################################################

XLIB_LIBXAW_VERSION = 1.0.11
XLIB_LIBXAW_SOURCE = libXaw-$(XLIB_LIBXAW_VERSION).tar.bz2
XLIB_LIBXAW_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXAW_LICENSE = MIT
XLIB_LIBXAW_LICENSE_FILES = COPYING
XLIB_LIBXAW_INSTALL_STAGING = YES
XLIB_LIBXAW_DEPENDENCIES = xlib_libX11 xlib_libXt xlib_libXmu xlib_libXpm xproto_xproto
XLIB_LIBXAW_CONF_OPT = --disable-docs

$(eval $(autotools-package))
