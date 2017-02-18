################################################################################
#
# xproto_scrnsaverproto
#
################################################################################

XPROTO_SCRNSAVERPROTO_VERSION = 1.2.2
XPROTO_SCRNSAVERPROTO_SOURCE = scrnsaverproto-$(XPROTO_SCRNSAVERPROTO_VERSION).tar.bz2
XPROTO_SCRNSAVERPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_SCRNSAVERPROTO_LICENSE = MIT
XPROTO_SCRNSAVERPROTO_LICENSE_FILES = COPYING
XPROTO_SCRNSAVERPROTO_INSTALL_STAGING = YES
XPROTO_SCRNSAVERPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
