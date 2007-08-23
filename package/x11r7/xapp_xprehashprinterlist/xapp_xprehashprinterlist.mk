################################################################################
#
# xapp_xprehashprinterlist -- Recomputes the list of available printers.
#
################################################################################

XAPP_XPREHASHPRINTERLIST_VERSION = 1.0.1
XAPP_XPREHASHPRINTERLIST_SOURCE = xprehashprinterlist-$(XAPP_XPREHASHPRINTERLIST_VERSION).tar.bz2
XAPP_XPREHASHPRINTERLIST_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XPREHASHPRINTERLIST_AUTORECONF = YES
XAPP_XPREHASHPRINTERLIST_DEPENDENCIES = xlib_libX11 xlib_libXp

$(eval $(call AUTOTARGETS,xapp_xprehashprinterlist))
