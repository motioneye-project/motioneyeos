################################################################################
#
# xapp_xdbedizzy -- X.Org xdbedizzy application
#
################################################################################

XAPP_XDBEDIZZY_VERSION = 1.0.2
XAPP_XDBEDIZZY_SOURCE = xdbedizzy-$(XAPP_XDBEDIZZY_VERSION).tar.bz2
XAPP_XDBEDIZZY_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XDBEDIZZY_AUTORECONF = NO
XAPP_XDBEDIZZY_DEPENDENCIES = xlib_libXext xlib_libXp xlib_libXprintUtil

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xdbedizzy))
