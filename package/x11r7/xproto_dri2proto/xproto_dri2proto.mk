################################################################################
#
# xproto_dri2proto -- X.Org DRI2 protocol headers
#
################################################################################

XPROTO_DRI2PROTO_VERSION = 2.3
XPROTO_DRI2PROTO_SOURCE = dri2proto-$(XPROTO_DRI2PROTO_VERSION).tar.bz2
XPROTO_DRI2PROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_DRI2PROTO_INSTALL_STAGING = YES
XPROTO_DRI2PROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
