################################################################################
#
# xproto_resourceproto -- X.Org Resource protocol headers
#
################################################################################

XPROTO_RESOURCEPROTO_VERSION = 1.1.0
XPROTO_RESOURCEPROTO_SOURCE = resourceproto-$(XPROTO_RESOURCEPROTO_VERSION).tar.bz2
XPROTO_RESOURCEPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_RESOURCEPROTO_INSTALL_STAGING = YES
XPROTO_RESOURCEPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
