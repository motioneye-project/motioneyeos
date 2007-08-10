################################################################################
#
# xproto_xproxymanagementprotocol -- X.Org PM protocol headers
#
################################################################################

XPROTO_XPROXYMANAGEMENTPROTOCOL_VERSION = 1.0.2
XPROTO_XPROXYMANAGEMENTPROTOCOL_SOURCE = xproxymanagementprotocol-$(XPROTO_XPROXYMANAGEMENTPROTOCOL_VERSION).tar.bz2
XPROTO_XPROXYMANAGEMENTPROTOCOL_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_XPROXYMANAGEMENTPROTOCOL_AUTORECONF = YES
XPROTO_XPROXYMANAGEMENTPROTOCOL_INSTALL_STAGING = YES
XPROTO_XPROXYMANAGEMENTPROTOCOL_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,xproto_xproxymanagementprotocol))
