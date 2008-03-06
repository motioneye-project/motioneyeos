################################################################################
#
# xapp_xinit -- X Window System initializer
#
################################################################################

XAPP_XINIT_VERSION = 1.0.5
XAPP_XINIT_SOURCE = xinit-$(XAPP_XINIT_VERSION).tar.bz2
XAPP_XINIT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XINIT_AUTORECONF = NO
XAPP_XINIT_DEPENDENCIES = xapp_xauth xlib_libX11

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xinit))
