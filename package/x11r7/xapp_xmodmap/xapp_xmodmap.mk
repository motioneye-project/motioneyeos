################################################################################
#
# xapp_xmodmap
#
################################################################################

XAPP_XMODMAP_VERSION = 1.0.7
XAPP_XMODMAP_SOURCE = xmodmap-$(XAPP_XMODMAP_VERSION).tar.bz2
XAPP_XMODMAP_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XMODMAP_LICENSE = MIT
XAPP_XMODMAP_LICENSE_FILES = COPYING
XAPP_XMODMAP_DEPENDENCIES = xlib_libX11

$(eval $(autotools-package))
