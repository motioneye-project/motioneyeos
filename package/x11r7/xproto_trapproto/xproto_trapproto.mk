################################################################################
#
# xproto_trapproto -- X.Org Trap protocol headers
#
################################################################################

XPROTO_TRAPPROTO_VERSION = 3.4.3
XPROTO_TRAPPROTO_SOURCE = trapproto-$(XPROTO_TRAPPROTO_VERSION).tar.bz2
XPROTO_TRAPPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_TRAPPROTO_AUTORECONF = YES
XPROTO_TRAPPROTO_INSTALL_STAGING = YES
XPROTO_TRAPPROTO_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,xproto_trapproto))
