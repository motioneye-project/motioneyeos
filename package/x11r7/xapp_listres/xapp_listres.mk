################################################################################
#
# xapp_listres -- list resources in widgets
#
################################################################################

XAPP_LISTRES_VERSION = 1.0.1
XAPP_LISTRES_SOURCE = listres-$(XAPP_LISTRES_VERSION).tar.bz2
XAPP_LISTRES_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_LISTRES_AUTORECONF = YES
XAPP_LISTRES_DEPENDENCIES = xlib_libX11 xlib_libXaw xlib_libXmu xlib_libXt

$(eval $(call AUTOTARGETS,xapp_listres))
