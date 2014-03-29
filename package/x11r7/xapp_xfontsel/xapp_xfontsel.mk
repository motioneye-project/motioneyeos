################################################################################
#
# xapp_xfontsel
#
################################################################################

XAPP_XFONTSEL_VERSION = 1.0.5
XAPP_XFONTSEL_SOURCE = xfontsel-$(XAPP_XFONTSEL_VERSION).tar.bz2
XAPP_XFONTSEL_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XFONTSEL_LICENSE = MIT
XAPP_XFONTSEL_LICENSE_FILES = COPYING
XAPP_XFONTSEL_DEPENDENCIES = xlib_libXaw

$(eval $(autotools-package))
