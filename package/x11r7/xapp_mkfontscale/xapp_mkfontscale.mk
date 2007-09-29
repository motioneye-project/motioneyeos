################################################################################
#
# xapp_mkfontscale -- create an index of scalable font files for X
#
################################################################################

XAPP_MKFONTSCALE_VERSION = 1.0.3
XAPP_MKFONTSCALE_SOURCE = mkfontscale-$(XAPP_MKFONTSCALE_VERSION).tar.bz2
XAPP_MKFONTSCALE_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_MKFONTSCALE_AUTORECONF = YES
XAPP_MKFONTSCALE_DEPENDENCIES = freetype xlib_libX11 xlib_libfontenc

$(eval $(call AUTOTARGETS,package/x11r7,xapp_mkfontscale))
