################################################################################
#
# xapp_setxkbmap
#
################################################################################

XAPP_SETXKBMAP_VERSION = 1.3.2
XAPP_SETXKBMAP_SOURCE = setxkbmap-$(XAPP_SETXKBMAP_VERSION).tar.bz2
XAPP_SETXKBMAP_SITE = https://xorg.freedesktop.org/archive/individual/app
XAPP_SETXKBMAP_LICENSE = MIT
XAPP_SETXKBMAP_LICENSE_FILES = COPYING
XAPP_SETXKBMAP_DEPENDENCIES = xlib_libX11 xlib_libxkbfile

$(eval $(autotools-package))
