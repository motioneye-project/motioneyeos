################################################################################
#
# xapp_xauth -- X authority file utility
#
################################################################################

XAPP_XAUTH_VERSION = 1.0.2
XAPP_XAUTH_SOURCE = xauth-$(XAPP_XAUTH_VERSION).tar.bz2
XAPP_XAUTH_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XAUTH_AUTORECONF = NO
XAPP_XAUTH_DEPENDENCIES = xlib_libX11 xlib_libXau xlib_libXext xlib_libXmu

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xauth))
