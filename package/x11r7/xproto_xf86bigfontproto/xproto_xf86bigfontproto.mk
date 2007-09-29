################################################################################
#
# xproto_xf86bigfontproto -- X.Org XF86BigFont protocol headers
#
################################################################################

XPROTO_XF86BIGFONTPROTO_VERSION = 1.1.2
XPROTO_XF86BIGFONTPROTO_SOURCE = xf86bigfontproto-$(XPROTO_XF86BIGFONTPROTO_VERSION).tar.bz2
XPROTO_XF86BIGFONTPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_XF86BIGFONTPROTO_AUTORECONF = YES
XPROTO_XF86BIGFONTPROTO_INSTALL_STAGING = YES
XPROTO_XF86BIGFONTPROTO_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,package/x11r7,xproto_xf86bigfontproto))
