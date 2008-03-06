################################################################################
#
# xapp_rgb -- uncompile an rgb color-name database
#
################################################################################

XAPP_RGB_VERSION = 1.0.1
XAPP_RGB_SOURCE = rgb-$(XAPP_RGB_VERSION).tar.bz2
XAPP_RGB_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_RGB_AUTORECONF = NO
XAPP_RGB_DEPENDENCIES = xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xapp_rgb))
