#############################################################
#
# smartmontools
#
#############################################################

SMARTMONTOOLS_VERSION = 5.42
SMARTMONTOOLS_SITE = http://downloads.sourceforge.net/project/smartmontools/smartmontools/$(SMARTMONTOOLS_VERSION)

$(eval $(autotools-package))
