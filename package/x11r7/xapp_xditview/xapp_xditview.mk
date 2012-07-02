################################################################################
#
# xapp_xditview -- display ditroff output
#
################################################################################

XAPP_XDITVIEW_VERSION = 1.0.1
XAPP_XDITVIEW_SOURCE = xditview-$(XAPP_XDITVIEW_VERSION).tar.bz2
XAPP_XDITVIEW_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XDITVIEW_DEPENDENCIES = xlib_libXaw

$(eval $(autotools-package))
