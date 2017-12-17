################################################################################
#
# xproto_dri3proto
#
################################################################################

XPROTO_DRI3PROTO_VERSION = 1.0
XPROTO_DRI3PROTO_SOURCE = dri3proto-$(XPROTO_DRI3PROTO_VERSION).tar.bz2
XPROTO_DRI3PROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_DRI3PROTO_LICENSE = MIT
XPROTO_DRI3PROTO_INSTALL_STAGING = YES
# this package does not contain any binary files
XPROTO_DRI3PROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
