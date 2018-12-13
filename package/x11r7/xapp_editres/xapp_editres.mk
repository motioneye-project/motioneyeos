################################################################################
#
# xapp_editres
#
################################################################################

XAPP_EDITRES_VERSION = 1.0.7
XAPP_EDITRES_SOURCE = editres-$(XAPP_EDITRES_VERSION).tar.bz2
XAPP_EDITRES_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_EDITRES_LICENSE = MIT
XAPP_EDITRES_LICENSE_FILES = COPYING
XAPP_EDITRES_DEPENDENCIES = xlib_libX11 xlib_libXaw xlib_libXmu xlib_libXt
XAPP_EDITRES_CONF_OPTS = --with-appdefaultdir=/usr/share/X11/app-defaults

$(eval $(autotools-package))
