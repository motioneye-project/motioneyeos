################################################################################
#
# xproto_videoproto
#
################################################################################

XPROTO_VIDEOPROTO_VERSION = 2.3.3
XPROTO_VIDEOPROTO_SOURCE = videoproto-$(XPROTO_VIDEOPROTO_VERSION).tar.bz2
XPROTO_VIDEOPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_VIDEOPROTO_LICENSE = MIT
XPROTO_VIDEOPROTO_LICENSE_FILES = COPYING
XPROTO_VIDEOPROTO_INSTALL_STAGING = YES
XPROTO_VIDEOPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
