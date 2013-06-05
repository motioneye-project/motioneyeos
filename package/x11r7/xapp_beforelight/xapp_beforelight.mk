################################################################################
#
# xapp_beforelight
#
################################################################################

XAPP_BEFORELIGHT_VERSION = 1.0.2
XAPP_BEFORELIGHT_SOURCE = beforelight-$(XAPP_BEFORELIGHT_VERSION).tar.bz2
XAPP_BEFORELIGHT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_BEFORELIGHT_LICENSE = MIT
XAPP_BEFORELIGHT_LICENSE_FILES = COPYING
XAPP_BEFORELIGHT_DEPENDENCIES = xlib_libX11 xlib_libXScrnSaver xlib_libXaw xlib_libXt

$(eval $(autotools-package))
