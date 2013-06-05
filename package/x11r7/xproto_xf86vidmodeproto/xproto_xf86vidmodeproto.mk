################################################################################
#
# xproto_xf86vidmodeproto
#
################################################################################

XPROTO_XF86VIDMODEPROTO_VERSION = 2.3.1
XPROTO_XF86VIDMODEPROTO_SOURCE = xf86vidmodeproto-$(XPROTO_XF86VIDMODEPROTO_VERSION).tar.bz2
XPROTO_XF86VIDMODEPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_XF86VIDMODEPROTO_LICENSE = MIT
XPROTO_XF86VIDMODEPROTO_LICENSE_FILES = COPYING
XPROTO_XF86VIDMODEPROTO_INSTALL_STAGING = YES
XPROTO_XF86VIDMODEPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
