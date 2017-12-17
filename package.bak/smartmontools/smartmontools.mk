################################################################################
#
# smartmontools
#
################################################################################

SMARTMONTOOLS_VERSION = 6.5
SMARTMONTOOLS_SITE = http://downloads.sourceforge.net/project/smartmontools/smartmontools/$(SMARTMONTOOLS_VERSION)
SMARTMONTOOLS_LICENSE = GPLv2+
SMARTMONTOOLS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
