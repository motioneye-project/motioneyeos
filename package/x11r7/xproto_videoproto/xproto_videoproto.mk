################################################################################
#
# xproto_videoproto -- X.Org Video protocol headers
#
################################################################################

XPROTO_VIDEOPROTO_VERSION = 2.3.0
XPROTO_VIDEOPROTO_SOURCE = videoproto-$(XPROTO_VIDEOPROTO_VERSION).tar.bz2
XPROTO_VIDEOPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_VIDEOPROTO_INSTALL_STAGING = YES
XPROTO_VIDEOPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
