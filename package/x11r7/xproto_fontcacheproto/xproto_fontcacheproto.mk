################################################################################
#
# xproto_fontcacheproto -- X.Org Fontcache protocol headers
#
################################################################################

XPROTO_FONTCACHEPROTO_VERSION = 0.1.2
XPROTO_FONTCACHEPROTO_SOURCE = fontcacheproto-$(XPROTO_FONTCACHEPROTO_VERSION).tar.bz2
XPROTO_FONTCACHEPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_FONTCACHEPROTO_AUTORECONF = YES
XPROTO_FONTCACHEPROTO_INSTALL_STAGING = YES
XPROTO_FONTCACHEPROTO_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,xproto_fontcacheproto))
