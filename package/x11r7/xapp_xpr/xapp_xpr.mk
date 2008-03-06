################################################################################
#
# xapp_xpr -- X.Org xpr application
#
################################################################################

XAPP_XPR_VERSION = 1.0.1
XAPP_XPR_SOURCE = xpr-$(XAPP_XPR_VERSION).tar.bz2
XAPP_XPR_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XPR_AUTORECONF = NO
XAPP_XPR_DEPENDENCIES = xlib_libX11 xlib_libXmu

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xpr))
