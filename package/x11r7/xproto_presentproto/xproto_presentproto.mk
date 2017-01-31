################################################################################
#
# xproto_presentproto
#
################################################################################

XPROTO_PRESENTPROTO_VERSION = 1.1
XPROTO_PRESENTPROTO_SOURCE = presentproto-$(XPROTO_PRESENTPROTO_VERSION).tar.bz2
XPROTO_PRESENTPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_PRESENTPROTO_LICENSE = MIT
XPROTO_PRESENTPROTO_LICENSE_FILES = presentproto.h
XPROTO_PRESENTPROTO_DEPENDENCIES = host-pkgconf xutil_util-macros
XPROTO_PRESENTPROTO_INSTALL_STAGING = YES
XPROTO_PRESENTPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
