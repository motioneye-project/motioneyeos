#############################################################
#
# ser2net
#
#############################################################

SER2NET_VERSION = 2.7
SER2NET_SOURCE = ser2net-$(SER2NET_VERSION).tar.gz
SER2NET_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/ser2net

$(eval $(call AUTOTARGETS,package,ser2net))
