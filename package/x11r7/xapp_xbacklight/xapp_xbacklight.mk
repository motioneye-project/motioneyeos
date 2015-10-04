################################################################################
#
# xapp_xbacklight
#
################################################################################

XAPP_XBACKLIGHT_VERSION = 1.2.1
XAPP_XBACKLIGHT_SOURCE = xbacklight-$(XAPP_XBACKLIGHT_VERSION).tar.bz2
XAPP_XBACKLIGHT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XBACKLIGHT_LICENSE = MIT
XAPP_XBACKLIGHT_LICENSE_FILES = COPYING
XAPP_XBACKLIGHT_DEPENDENCIES = xlib_libX11 xlib_libXrandr xlib_libXrender xcb-util

$(eval $(autotools-package))
