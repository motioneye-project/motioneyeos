################################################################################
#
# xproto_fixesproto -- X.Org Fixes protocol headers
#
################################################################################

XPROTO_FIXESPROTO_VERSION = 4.0
XPROTO_FIXESPROTO_SOURCE = fixesproto-$(XPROTO_FIXESPROTO_VERSION).tar.bz2
XPROTO_FIXESPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_FIXESPROTO_AUTORECONF = NO
XPROTO_FIXESPROTO_INSTALL_STAGING = YES
XPROTO_FIXESPROTO_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,package/x11r7,xproto_fixesproto))
