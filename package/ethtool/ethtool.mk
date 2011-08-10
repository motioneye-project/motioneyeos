#############################################################
#
# ethtool
#
#############################################################

ETHTOOL_VERSION = 3.0
ETHTOOL_SITE = $(BR2_KERNEL_MIRROR)/software/network/ethtool/

$(eval $(call AUTOTARGETS,package,ethtool))
