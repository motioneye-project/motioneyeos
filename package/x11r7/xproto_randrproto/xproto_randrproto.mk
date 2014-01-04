################################################################################
#
# xproto_randrproto
#
################################################################################

XPROTO_RANDRPROTO_VERSION = 1.4.0
XPROTO_RANDRPROTO_SOURCE = randrproto-$(XPROTO_RANDRPROTO_VERSION).tar.bz2
XPROTO_RANDRPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_RANDRPROTO_LICENSE = MIT
XPROTO_RANDRPROTO_LICENSE_FILES = COPYING
XPROTO_RANDRPROTO_INSTALL_STAGING = YES
XPROTO_RANDRPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
