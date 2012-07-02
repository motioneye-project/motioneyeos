################################################################################
#
# xproto_xf86bigfontproto -- X.Org XF86BigFont protocol headers
#
################################################################################

XPROTO_XF86BIGFONTPROTO_VERSION = 1.2.0
XPROTO_XF86BIGFONTPROTO_SOURCE = xf86bigfontproto-$(XPROTO_XF86BIGFONTPROTO_VERSION).tar.bz2
XPROTO_XF86BIGFONTPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_XF86BIGFONTPROTO_INSTALL_STAGING = YES
XPROTO_XF86BIGFONTPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
$(eval $(host-autotools-package))
