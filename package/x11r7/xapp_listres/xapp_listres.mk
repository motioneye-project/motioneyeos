################################################################################
#
# xapp_listres
#
################################################################################

XAPP_LISTRES_VERSION = 1.0.3
XAPP_LISTRES_SOURCE = listres-$(XAPP_LISTRES_VERSION).tar.bz2
XAPP_LISTRES_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_LISTRES_LICENSE = MIT
XAPP_LISTRES_LICENSE_FILES = COPYING
XAPP_LISTRES_DEPENDENCIES = xlib_libX11 xlib_libXaw xlib_libXmu xlib_libXt

$(eval $(autotools-package))
