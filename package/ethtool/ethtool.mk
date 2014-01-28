################################################################################
#
# ethtool
#
################################################################################

ETHTOOL_VERSION = 3.13
ETHTOOL_SOURCE = ethtool-$(ETHTOOL_VERSION).tar.xz
ETHTOOL_SITE = $(BR2_KERNEL_MIRROR)/software/network/ethtool
ETHTOOL_LICENSE = GPLv2
ETHTOOL_LICENSE_FILES = COPYING

$(eval $(autotools-package))
