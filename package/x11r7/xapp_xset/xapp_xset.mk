################################################################################
#
# xapp_xset -- X.Org xset application
#
################################################################################

XAPP_XSET_VERSION = 1.0.2
XAPP_XSET_SOURCE = xset-$(XAPP_XSET_VERSION).tar.bz2
XAPP_XSET_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XSET_AUTORECONF = YES
XAPP_XSET_DEPENDENCIES = xlib_libXfontcache xlib_libXmu

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xset))
