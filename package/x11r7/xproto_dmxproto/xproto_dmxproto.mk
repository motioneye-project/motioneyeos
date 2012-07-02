################################################################################
#
# xproto_dmxproto -- X.Org DMX protocol headers
#
################################################################################

XPROTO_DMXPROTO_VERSION = 2.3
XPROTO_DMXPROTO_SOURCE = dmxproto-$(XPROTO_DMXPROTO_VERSION).tar.bz2
XPROTO_DMXPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_DMXPROTO_INSTALL_STAGING = YES
XPROTO_DMXPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
