################################################################################
#
# xapp_xinit -- X Window System initializer
#
################################################################################

XAPP_XINIT_VERSION = 1.0.3
XAPP_XINIT_SOURCE = xinit-$(XAPP_XINIT_VERSION).tar.bz2
XAPP_XINIT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XINIT_AUTORECONF = YES
XAPP_XINIT_DEPENDANCIES = xapp_xauth xlib_libX11

$(eval $(call AUTOTARGETS,xapp_xinit))
