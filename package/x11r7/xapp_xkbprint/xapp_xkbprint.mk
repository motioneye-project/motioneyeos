################################################################################
#
# xapp_xkbprint
#
################################################################################

XAPP_XKBPRINT_VERSION = 1.0.4
XAPP_XKBPRINT_SOURCE = xkbprint-$(XAPP_XKBPRINT_VERSION).tar.bz2
XAPP_XKBPRINT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XKBPRINT_LICENSE = MIT
XAPP_XKBPRINT_LICENSE_FILES = COPYING
XAPP_XKBPRINT_DEPENDENCIES = xlib_libxkbfile

$(eval $(autotools-package))
