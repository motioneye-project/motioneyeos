################################################################################
#
# xproto_glproto
#
################################################################################

XPROTO_GLPROTO_VERSION = 1.4.15
XPROTO_GLPROTO_SOURCE = glproto-$(XPROTO_GLPROTO_VERSION).tar.bz2
XPROTO_GLPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_GLPROTO_LICENSE = MIT
XPROTO_GLPROTO_LICENSE_FILES = COPYING
XPROTO_GLPROTO_INSTALL_STAGING = YES
XPROTO_GLPROTO_INSTALL_TARGET = NO

$(eval $(autotools-package))
