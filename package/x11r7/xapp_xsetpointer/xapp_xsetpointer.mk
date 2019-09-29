################################################################################
#
# xapp_xsetpointer
#
################################################################################

XAPP_XSETPOINTER_VERSION = 1.0.1
XAPP_XSETPOINTER_SOURCE = xsetpointer-$(XAPP_XSETPOINTER_VERSION).tar.bz2
XAPP_XSETPOINTER_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XSETPOINTER_LICENSE = MIT
XAPP_XSETPOINTER_LICENSE_FILES = COPYING
XAPP_XSETPOINTER_DEPENDENCIES = xlib_libX11 xlib_libXi xorgproto

$(eval $(autotools-package))
