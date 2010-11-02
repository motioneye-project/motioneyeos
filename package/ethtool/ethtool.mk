#############################################################
#
# ethtool
#
#############################################################

ETHTOOL_VERSION = 2.6.35
ETHTOOL_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/gkernel/

$(eval $(call AUTOTARGETS,package,ethtool))
