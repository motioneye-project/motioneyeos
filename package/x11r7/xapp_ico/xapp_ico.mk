################################################################################
#
# xapp_ico
#
################################################################################

XAPP_ICO_VERSION = 1.0.4
XAPP_ICO_SOURCE = ico-$(XAPP_ICO_VERSION).tar.bz2
XAPP_ICO_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_ICO_LICENSE = MIT
XAPP_ICO_LICENSE_FILES = COPYING
XAPP_ICO_DEPENDENCIES = xlib_libX11

$(eval $(autotools-package))
