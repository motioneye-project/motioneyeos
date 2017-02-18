################################################################################
#
# xproto_xproxymanagementprotocol
#
################################################################################

XPROTO_XPROXYMANAGEMENTPROTOCOL_VERSION = 1.0.3
XPROTO_XPROXYMANAGEMENTPROTOCOL_SOURCE = xproxymanagementprotocol-$(XPROTO_XPROXYMANAGEMENTPROTOCOL_VERSION).tar.bz2
XPROTO_XPROXYMANAGEMENTPROTOCOL_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_XPROXYMANAGEMENTPROTOCOL_LICENSE = MIT
XPROTO_XPROXYMANAGEMENTPROTOCOL_LICENSE_FILES = COPYING
XPROTO_XPROXYMANAGEMENTPROTOCOL_INSTALL_STAGING = YES
XPROTO_XPROXYMANAGEMENTPROTOCOL_INSTALL_TARGET = NO

$(eval $(autotools-package))
