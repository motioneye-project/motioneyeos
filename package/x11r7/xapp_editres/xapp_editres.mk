################################################################################
#
# xapp_editres -- a dynamic resource editor for X Toolkit applications
#
################################################################################

XAPP_EDITRES_VERSION = 1.0.2
XAPP_EDITRES_SOURCE = editres-$(XAPP_EDITRES_VERSION).tar.bz2
XAPP_EDITRES_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_EDITRES_DEPENDENCIES = xlib_libX11 xlib_libXaw xlib_libXmu xlib_libXt

$(eval $(autotools-package))
