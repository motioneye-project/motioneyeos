################################################################################
#
# netcat
#
################################################################################

NETCAT_VERSION = 0.7.1
NETCAT_SITE = http://downloads.sourceforge.net/project/netcat/netcat/$(NETCAT_VERSION)

$(eval $(autotools-package))
