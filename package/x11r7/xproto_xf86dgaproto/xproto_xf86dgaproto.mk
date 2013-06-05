################################################################################
#
# xproto_xf86dgaproto
#
################################################################################

XPROTO_XF86DGAPROTO_VERSION = 2.1
XPROTO_XF86DGAPROTO_SOURCE = xf86dgaproto-$(XPROTO_XF86DGAPROTO_VERSION).tar.bz2
XPROTO_XF86DGAPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_XF86DGAPROTO_LICENSE = MIT
XPROTO_XF86DGAPROTO_LICENSE_FILES = COPYING
XPROTO_XF86DGAPROTO_INSTALL_STAGING = YES
XPROTO_XF86DGAPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
