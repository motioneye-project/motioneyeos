################################################################################
#
# xproto_xf86driproto -- X.Org XF86DRI protocol headers
#
################################################################################

XPROTO_XF86DRIPROTO_VERSION = 2.1.0
XPROTO_XF86DRIPROTO_SOURCE = xf86driproto-$(XPROTO_XF86DRIPROTO_VERSION).tar.bz2
XPROTO_XF86DRIPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_XF86DRIPROTO_INSTALL_STAGING = YES
XPROTO_XF86DRIPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
