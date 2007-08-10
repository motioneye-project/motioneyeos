################################################################################
#
# xproto_evieext -- X.Org EvIE protocol headers
#
################################################################################

XPROTO_EVIEEXT_VERSION = 1.0.2
XPROTO_EVIEEXT_SOURCE = evieext-$(XPROTO_EVIEEXT_VERSION).tar.bz2
XPROTO_EVIEEXT_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_EVIEEXT_AUTORECONF = YES
XPROTO_EVIEEXT_INSTALL_STAGING = YES
XPROTO_EVIEEXT_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,xproto_evieext))
