################################################################################
#
# netcat
#
################################################################################

NETCAT_VERSION = 0.7.1
NETCAT_SITE = http://downloads.sourceforge.net/project/netcat/netcat/$(NETCAT_VERSION)
NETCAT_LICENSE = GPLv2+
NETCAT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
