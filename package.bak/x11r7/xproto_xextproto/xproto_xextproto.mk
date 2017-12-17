################################################################################
#
# xproto_xextproto
#
################################################################################

XPROTO_XEXTPROTO_VERSION = 7.3.0
XPROTO_XEXTPROTO_SOURCE = xextproto-$(XPROTO_XEXTPROTO_VERSION).tar.bz2
XPROTO_XEXTPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_XEXTPROTO_LICENSE = MIT
XPROTO_XEXTPROTO_LICENSE_FILES = COPYING
XPROTO_XEXTPROTO_INSTALL_STAGING = YES
XPROTO_XEXTPROTO_CONF_OPTS = --disable-specs
HOST_XPROTO_XEXTPROTO_CONF_OPTS = --disable-specs

$(eval $(autotools-package))
$(eval $(host-autotools-package))
