################################################################################
#
# xproto_recordproto -- X.Org Record protocol headers
#
################################################################################

XPROTO_RECORDPROTO_VERSION = 1.14
XPROTO_RECORDPROTO_SOURCE = recordproto-$(XPROTO_RECORDPROTO_VERSION).tar.bz2
XPROTO_RECORDPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_RECORDPROTO_INSTALL_STAGING = YES
XPROTO_RECORDPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
