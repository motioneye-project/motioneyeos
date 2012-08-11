#############################################################
#
# ethtool
#
#############################################################

ETHTOOL_VERSION = 3.5
ETHTOOL_SITE = $(BR2_KERNEL_MIRROR)/software/network/ethtool
ETHTOOL_LICENSE = GPLv2
ETHTOOL_LICENSE_FILE = COPYING

$(eval $(autotools-package))
