################################################################################
#
# xproto_kbproto -- X.Org KB protocol headers
#
################################################################################

XPROTO_KBPROTO_VERSION = 1.0.4
XPROTO_KBPROTO_SOURCE = kbproto-$(XPROTO_KBPROTO_VERSION).tar.bz2
XPROTO_KBPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_KBPROTO_INSTALL_STAGING = YES
XPROTO_KBPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
$(eval $(host-autotools-package))
