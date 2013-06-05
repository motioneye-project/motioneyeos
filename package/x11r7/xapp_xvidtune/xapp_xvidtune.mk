################################################################################
#
# xapp_xvidtune
#
################################################################################

XAPP_XVIDTUNE_VERSION = 1.0.2
XAPP_XVIDTUNE_SOURCE = xvidtune-$(XAPP_XVIDTUNE_VERSION).tar.bz2
XAPP_XVIDTUNE_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XVIDTUNE_LICENSE = MIT
XAPP_XVIDTUNE_LICENSE_FILES = COPYING
XAPP_XVIDTUNE_DEPENDENCIES = xlib_libXaw xlib_libXxf86vm

$(eval $(autotools-package))
