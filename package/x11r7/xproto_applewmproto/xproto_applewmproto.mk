################################################################################
#
# xproto_applewmproto
#
################################################################################

XPROTO_APPLEWMPROTO_VERSION = 1.4.2
XPROTO_APPLEWMPROTO_SOURCE = applewmproto-$(XPROTO_APPLEWMPROTO_VERSION).tar.bz2
XPROTO_APPLEWMPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_APPLEWMPROTO_LICENSE = MIT
XPROTO_APPLEWMPROTO_LICENSE_FILES = COPYING
XPROTO_APPLEWMPROTO_INSTALL_STAGING = YES
XPROTO_APPLEWMPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
