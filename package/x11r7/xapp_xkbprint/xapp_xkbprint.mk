################################################################################
#
# xapp_xkbprint -- print an XKB keyboard description
#
################################################################################

XAPP_XKBPRINT_VERSION = 1.0.1
XAPP_XKBPRINT_SOURCE = xkbprint-$(XAPP_XKBPRINT_VERSION).tar.bz2
XAPP_XKBPRINT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XKBPRINT_AUTORECONF = YES
XAPP_XKBPRINT_DEPENDENCIES = xlib_libxkbfile

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xkbprint))
