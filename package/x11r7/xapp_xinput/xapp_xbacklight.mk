################################################################################
#
# xapp_xinput -- xinput
#
################################################################################

XAPP_XINPUT_VERSION = 1.3.0
XAPP_XINPUT_SOURCE = xinput-$(XAPP_XINPUT_VERSION).tar.bz2
XAPP_XINPUT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XINPUT_AUTORECONF = NO
XAPP_XINPUT_DEPENDENCIES = xlib_libX11

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xinput))
