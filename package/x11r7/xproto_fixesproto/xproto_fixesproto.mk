################################################################################
#
# xproto_fixesproto
#
################################################################################

XPROTO_FIXESPROTO_VERSION = 5.0
XPROTO_FIXESPROTO_SOURCE = fixesproto-$(XPROTO_FIXESPROTO_VERSION).tar.bz2
XPROTO_FIXESPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_FIXESPROTO_LICENSE = MIT
XPROTO_FIXESPROTO_LICENSE_FILES = COPYING
XPROTO_FIXESPROTO_INSTALL_STAGING = YES
XPROTO_FIXESPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
$(eval $(host-autotools-package))
