################################################################################
#
# xproto_renderproto
#
################################################################################

XPROTO_RENDERPROTO_VERSION = 0.11.1
XPROTO_RENDERPROTO_SOURCE = renderproto-$(XPROTO_RENDERPROTO_VERSION).tar.bz2
XPROTO_RENDERPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_RENDERPROTO_LICENSE = MIT
XPROTO_RENDERPROTO_LICENSE_FILES = COPYING
XPROTO_RENDERPROTO_INSTALL_STAGING = YES
XPROTO_RENDERPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
$(eval $(host-autotools-package))
