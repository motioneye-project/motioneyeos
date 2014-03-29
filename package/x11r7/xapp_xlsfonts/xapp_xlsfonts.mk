################################################################################
#
# xapp_xlsfonts
#
################################################################################

XAPP_XLSFONTS_VERSION = 1.0.4
XAPP_XLSFONTS_SOURCE = xlsfonts-$(XAPP_XLSFONTS_VERSION).tar.bz2
XAPP_XLSFONTS_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XLSFONTS_LICENSE = MIT
XAPP_XLSFONTS_LICENSE_FILES = COPYING
XAPP_XLSFONTS_DEPENDENCIES = xlib_libX11

$(eval $(autotools-package))
