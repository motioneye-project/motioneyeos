#############################################################
#
# smartmontools
#
#############################################################

SMARTMONTOOLS_VERSION = 5.40
SMARTMONTOOLS_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/smartmontools

$(eval $(call AUTOTARGETS,package,smartmontools))
