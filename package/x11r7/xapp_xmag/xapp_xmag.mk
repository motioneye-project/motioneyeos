################################################################################
#
# xapp_xmag -- X.Org xmag application
#
################################################################################

XAPP_XMAG_VERSION = 1.0.1
XAPP_XMAG_SOURCE = xmag-$(XAPP_XMAG_VERSION).tar.bz2
XAPP_XMAG_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XMAG_AUTORECONF = YES
XAPP_XMAG_DEPENDENCIES = xlib_libXaw

$(eval $(call AUTOTARGETS,xapp_xmag))
