################################################################################
#
# netstat-nat
#
################################################################################

NETSTAT_NAT_VERSION = 1.4.10
NETSTAT_NAT_SITE = http://tweegy.nl/download
NETSTAT_NAT_LICENSE = GPLv2+
NETSTAT_NAT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
