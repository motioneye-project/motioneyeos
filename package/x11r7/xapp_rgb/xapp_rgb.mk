################################################################################
#
# xapp_rgb
#
################################################################################

XAPP_RGB_VERSION = 1.0.1
XAPP_RGB_SOURCE = rgb-$(XAPP_RGB_VERSION).tar.bz2
XAPP_RGB_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_RGB_LICENSE = MIT
XAPP_RGB_LICENSE_FILES = COPYING
XAPP_RGB_DEPENDENCIES = xproto_xproto

$(eval $(autotools-package))
