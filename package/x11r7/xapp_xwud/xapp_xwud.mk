################################################################################
#
# xapp_xwud -- image displayer for X
#
################################################################################

XAPP_XWUD_VERSION = 1.0.2
XAPP_XWUD_SOURCE = xwud-$(XAPP_XWUD_VERSION).tar.bz2
XAPP_XWUD_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XWUD_DEPENDENCIES = xlib_libX11

$(eval $(autotools-package))
