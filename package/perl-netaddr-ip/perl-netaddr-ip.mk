################################################################################
#
# perl-netaddr-ip
#
################################################################################

PERL_NETADDR_IP_VERSION = 4.079
PERL_NETADDR_IP_SOURCE = NetAddr-IP-$(PERL_NETADDR_IP_VERSION).tar.gz
PERL_NETADDR_IP_SITE = $(BR2_CPAN_MIRROR)/authors/id/M/MI/MIKER
PERL_NETADDR_IP_LICENSE = Artistic or GPL-1.0+
PERL_NETADDR_IP_LICENSE_FILES = Artistic Copying
PERL_NETADDR_IP_DISTNAME = NetAddr-IP

ifeq ($(BR2_STATIC_LIBS),y)
PERL_NETADDR_IP_CONF_OPTS = -noxs
endif

$(eval $(perl-package))
