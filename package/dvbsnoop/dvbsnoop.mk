################################################################################
#
# dvbsnoop
#
################################################################################

DVBSNOOP_VERSION = 1.4.50
DVBSNOOP_SITE = http://downloads.sourceforge.net/project/dvbsnoop/dvbsnoop/dvbsnoop-$(DVBSNOOP_VERSION)
DVBSNOOP_LICENSE = GPL-2.0
DVBSNOOP_LICENSE_FILES = COPYING

$(eval $(autotools-package))
