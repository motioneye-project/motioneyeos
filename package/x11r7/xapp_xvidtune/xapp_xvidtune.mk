################################################################################
#
# xapp_xvidtune -- video mode tuner for Xorg
#
################################################################################

XAPP_XVIDTUNE_VERSION = 1.0.1
XAPP_XVIDTUNE_SOURCE = xvidtune-$(XAPP_XVIDTUNE_VERSION).tar.bz2
XAPP_XVIDTUNE_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XVIDTUNE_AUTORECONF = NO
XAPP_XVIDTUNE_DEPENDENCIES = xlib_libXaw xlib_libXxf86vm

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xvidtune))
