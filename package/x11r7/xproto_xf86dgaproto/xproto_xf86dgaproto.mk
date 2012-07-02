################################################################################
#
# xproto_xf86dgaproto -- X.Org XF86DGA protocol headers
#
################################################################################

XPROTO_XF86DGAPROTO_VERSION = 2.1
XPROTO_XF86DGAPROTO_SOURCE = xf86dgaproto-$(XPROTO_XF86DGAPROTO_VERSION).tar.bz2
XPROTO_XF86DGAPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_XF86DGAPROTO_INSTALL_STAGING = YES
XPROTO_XF86DGAPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
