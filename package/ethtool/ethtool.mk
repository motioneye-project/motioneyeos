#############################################################
#
# ethtool
#
#############################################################

ETHTOOL_VERSION = 3.4.1
ETHTOOL_SITE = $(BR2_KERNEL_MIRROR)/software/network/ethtool

$(eval $(autotools-package))
