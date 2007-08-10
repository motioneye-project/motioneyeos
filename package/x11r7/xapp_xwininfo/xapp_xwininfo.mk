################################################################################
#
# xapp_xwininfo -- window information utility for X
#
################################################################################

XAPP_XWININFO_VERSION = 1.0.2
XAPP_XWININFO_SOURCE = xwininfo-$(XAPP_XWININFO_VERSION).tar.bz2
XAPP_XWININFO_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XWININFO_AUTORECONF = YES
XAPP_XWININFO_DEPENDANCIES = xlib_libX11 xlib_libXmu

$(eval $(call AUTOTARGETS,xapp_xwininfo))
