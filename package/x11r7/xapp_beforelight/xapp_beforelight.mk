################################################################################
#
# xapp_beforelight -- screen saver
#
################################################################################

XAPP_BEFORELIGHT_VERSION = 1.0.2
XAPP_BEFORELIGHT_SOURCE = beforelight-$(XAPP_BEFORELIGHT_VERSION).tar.bz2
XAPP_BEFORELIGHT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_BEFORELIGHT_AUTORECONF = YES
XAPP_BEFORELIGHT_DEPENDENCIES = xlib_libX11 xlib_libXScrnSaver xlib_libXaw xlib_libXt

$(eval $(call AUTOTARGETS,package/x11r7,xapp_beforelight))
