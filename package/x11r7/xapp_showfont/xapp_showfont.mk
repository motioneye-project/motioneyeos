################################################################################
#
# xapp_showfont
#
################################################################################

XAPP_SHOWFONT_VERSION = 1.0.5
XAPP_SHOWFONT_SOURCE = showfont-$(XAPP_SHOWFONT_VERSION).tar.bz2
XAPP_SHOWFONT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_SHOWFONT_LICENSE = MIT
XAPP_SHOWFONT_LICENSE_FILES = COPYING
XAPP_SHOWFONT_DEPENDENCIES = xlib_libFS

$(eval $(autotools-package))
