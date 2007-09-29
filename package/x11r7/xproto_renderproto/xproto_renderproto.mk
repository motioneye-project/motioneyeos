################################################################################
#
# xproto_renderproto -- X.Org Render protocol headers
#
################################################################################

XPROTO_RENDERPROTO_VERSION = 0.9.2
XPROTO_RENDERPROTO_SOURCE = renderproto-$(XPROTO_RENDERPROTO_VERSION).tar.bz2
XPROTO_RENDERPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_RENDERPROTO_AUTORECONF = YES
XPROTO_RENDERPROTO_INSTALL_STAGING = YES
XPROTO_RENDERPROTO_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,package/x11r7,xproto_renderproto))
