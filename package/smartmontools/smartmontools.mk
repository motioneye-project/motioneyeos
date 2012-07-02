#############################################################
#
# smartmontools
#
#############################################################

SMARTMONTOOLS_VERSION = 5.42
SMARTMONTOOLS_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/smartmontools

$(eval $(autotools-package))
