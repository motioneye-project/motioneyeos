################################################################################
#
# xapp_xset -- X.Org xset application
#
################################################################################

XAPP_XSET_VERSION = 1.1.0
XAPP_XSET_SOURCE = xset-$(XAPP_XSET_VERSION).tar.bz2
XAPP_XSET_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XSET_DEPENDENCIES = xlib_libXfontcache xlib_libXmu

$(eval $(autotools-package))
