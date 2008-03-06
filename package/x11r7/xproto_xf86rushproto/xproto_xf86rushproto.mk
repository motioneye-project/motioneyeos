################################################################################
#
# xproto_xf86rushproto -- X.Org XF86Rush protocol headers
#
################################################################################

XPROTO_XF86RUSHPROTO_VERSION = 1.1.2
XPROTO_XF86RUSHPROTO_SOURCE = xf86rushproto-$(XPROTO_XF86RUSHPROTO_VERSION).tar.bz2
XPROTO_XF86RUSHPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_XF86RUSHPROTO_AUTORECONF = NO
XPROTO_XF86RUSHPROTO_INSTALL_STAGING = YES
XPROTO_XF86RUSHPROTO_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,package/x11r7,xproto_xf86rushproto))
