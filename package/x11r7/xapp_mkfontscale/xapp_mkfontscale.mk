################################################################################
#
# xapp_mkfontscale
#
################################################################################

XAPP_MKFONTSCALE_VERSION = 1.1.2
XAPP_MKFONTSCALE_SOURCE = mkfontscale-$(XAPP_MKFONTSCALE_VERSION).tar.bz2
XAPP_MKFONTSCALE_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_MKFONTSCALE_LICENSE = MIT
XAPP_MKFONTSCALE_LICENSE_FILES = COPYING
XAPP_MKFONTSCALE_DEPENDENCIES = zlib freetype xlib_libfontenc xproto_xproto
HOST_XAPP_MKFONTSCALE_DEPENDENCIES = \
	host-zlib host-freetype host-xlib_libfontenc host-xproto_xproto

$(eval $(autotools-package))
$(eval $(host-autotools-package))
