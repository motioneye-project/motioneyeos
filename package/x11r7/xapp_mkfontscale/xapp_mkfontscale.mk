################################################################################
#
# xapp_mkfontscale -- create an index of scalable font files for X
#
################################################################################

XAPP_MKFONTSCALE_VERSION = 1.0.7
XAPP_MKFONTSCALE_SOURCE = mkfontscale-$(XAPP_MKFONTSCALE_VERSION).tar.bz2
XAPP_MKFONTSCALE_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_MKFONTSCALE_DEPENDENCIES = zlib freetype xlib_libfontenc xproto_xproto

$(eval $(autotools-package))
$(eval $(host-autotools-package))
