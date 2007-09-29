################################################################################
#
# xapp_xmore -- plain text display program for the X Window System
#
################################################################################

XAPP_XMORE_VERSION = 1.0.1
XAPP_XMORE_SOURCE = xmore-$(XAPP_XMORE_VERSION).tar.bz2
XAPP_XMORE_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XMORE_AUTORECONF = YES
XAPP_XMORE_DEPENDENCIES = xlib_libXprintUtil xlib_libXprintUtil

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xmore))
