################################################################################
#
# xlib_libdmx
#
################################################################################

XLIB_LIBDMX_VERSION = 1.1.3
XLIB_LIBDMX_SOURCE = libdmx-$(XLIB_LIBDMX_VERSION).tar.bz2
XLIB_LIBDMX_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBDMX_LICENSE = MIT
XLIB_LIBDMX_LICENSE_FILES = COPYING
XLIB_LIBDMX_INSTALL_STAGING = YES
XLIB_LIBDMX_DEPENDENCIES = xlib_libX11 xlib_libXext xproto_dmxproto
XLIB_LIBDMX_CONF_OPT = --disable-malloc0returnsnull

$(eval $(autotools-package))
