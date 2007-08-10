################################################################################
#
# xapp_appres -- list X application resource database
#
################################################################################

XAPP_APPRES_VERSION = 1.0.1
XAPP_APPRES_SOURCE = appres-$(XAPP_APPRES_VERSION).tar.bz2
XAPP_APPRES_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_APPRES_AUTORECONF = YES
XAPP_APPRES_DEPENDANCIES = xlib_libX11 xlib_libXt

$(eval $(call AUTOTARGETS,xapp_appres))
