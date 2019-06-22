################################################################################
#
# xfont_encodings
#
################################################################################

XFONT_ENCODINGS_VERSION = 1.0.5
XFONT_ENCODINGS_SOURCE = encodings-$(XFONT_ENCODINGS_VERSION).tar.bz2
XFONT_ENCODINGS_SITE = https://xorg.freedesktop.org/releases/individual/font
XFONT_ENCODINGS_LICENSE = Public Domain
XFONT_ENCODINGS_LICENSE_FILES = COPYING

XFONT_ENCODINGS_DEPENDENCIES = host-xapp_mkfontscale host-pkgconf xutil_util-macros
HOST_XFONT_ENCODINGS_DEPENDENCIES = \
	host-xapp_mkfontscale host-pkgconf host-xutil_util-macros

$(eval $(autotools-package))
$(eval $(host-autotools-package))
