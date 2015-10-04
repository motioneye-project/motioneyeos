################################################################################
#
# xapp_xsetmode
#
################################################################################

XAPP_XSETMODE_VERSION = 1.0.0
XAPP_XSETMODE_SOURCE = xsetmode-$(XAPP_XSETMODE_VERSION).tar.bz2
XAPP_XSETMODE_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XSETMODE_LICENSE = MIT
XAPP_XSETMODE_LICENSE_FILES = COPYING
XAPP_XSETMODE_DEPENDENCIES = xlib_libX11 xlib_libXi

$(eval $(autotools-package))
