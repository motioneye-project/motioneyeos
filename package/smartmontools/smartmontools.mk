#############################################################
#
# smartmontools
#
#############################################################

SMARTMONTOOLS_VERSION = 5.43
SMARTMONTOOLS_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/smartmontools
SMARTMONTOOLS_LICENSE = GPLv2+
SMARTMONTOOLS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
