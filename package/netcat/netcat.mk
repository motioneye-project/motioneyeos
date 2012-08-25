#############################################################
#
# netcat
#
#############################################################

NETCAT_VERSION:=0.7.1
NETCAT_SOURCE:=netcat-$(NETCAT_VERSION).tar.gz
NETCAT_SITE=http://downloads.sourceforge.net/project/netcat/netcat/$(NETCAT_VERSION)

$(eval $(autotools-package))
