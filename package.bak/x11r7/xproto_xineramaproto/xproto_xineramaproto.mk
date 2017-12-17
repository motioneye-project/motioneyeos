################################################################################
#
# xproto_xineramaproto
#
################################################################################

XPROTO_XINERAMAPROTO_VERSION = 1.2.1
XPROTO_XINERAMAPROTO_SOURCE = xineramaproto-$(XPROTO_XINERAMAPROTO_VERSION).tar.bz2
XPROTO_XINERAMAPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_XINERAMAPROTO_LICENSE = MIT
XPROTO_XINERAMAPROTO_LICENSE_FILES = COPYING
XPROTO_XINERAMAPROTO_INSTALL_STAGING = YES
XPROTO_XINERAMAPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
