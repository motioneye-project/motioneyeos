################################################################################
#
# xproto_xextproto -- X.Org XExt protocol headers
#
################################################################################

XPROTO_XEXTPROTO_VERSION = 7.0.2
XPROTO_XEXTPROTO_SOURCE = xextproto-$(XPROTO_XEXTPROTO_VERSION).tar.bz2
XPROTO_XEXTPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_XEXTPROTO_AUTORECONF = YES
XPROTO_XEXTPROTO_INSTALL_STAGING = YES
XPROTO_XEXTPROTO_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,package/x11r7,xproto_xextproto))
