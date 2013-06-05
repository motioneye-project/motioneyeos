################################################################################
#
# xproto_fontcacheproto
#
################################################################################

XPROTO_FONTCACHEPROTO_VERSION = 0.1.3
XPROTO_FONTCACHEPROTO_SOURCE = fontcacheproto-$(XPROTO_FONTCACHEPROTO_VERSION).tar.bz2
XPROTO_FONTCACHEPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_FONTCACHEPROTO_LICENSE = MIT
XPROTO_FONTCACHEPROTO_LICENSE_FILES = COPYING
XPROTO_FONTCACHEPROTO_INSTALL_STAGING = YES
XPROTO_FONTCACHEPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
$(eval $(host-autotools-package))
