################################################################################
#
# xproto_fontsproto -- X.Org Fonts protocol headers
#
################################################################################

XPROTO_FONTSPROTO_VERSION = 2.1.0
XPROTO_FONTSPROTO_SOURCE = fontsproto-$(XPROTO_FONTSPROTO_VERSION).tar.bz2
XPROTO_FONTSPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_FONTSPROTO_INSTALL_STAGING = YES
XPROTO_FONTSPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
$(eval $(host-autotools-package))
