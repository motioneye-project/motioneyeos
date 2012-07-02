################################################################################
#
# xproto_xproto -- X.Org xproto protocol headers
#
################################################################################

XPROTO_XPROTO_VERSION = 7.0.16
XPROTO_XPROTO_SOURCE = xproto-$(XPROTO_XPROTO_VERSION).tar.bz2
XPROTO_XPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_XPROTO_INSTALL_STAGING = YES
XPROTO_XPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
$(eval $(host-autotools-package))
