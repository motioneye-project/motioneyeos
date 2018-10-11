################################################################################
#
# perl-net-snmp
#
################################################################################

PERL_NET_SNMP_VERSION = v6.0.1
PERL_NET_SNMP_SOURCE = Net-SNMP-$(PERL_NET_SNMP_VERSION).tar.gz
PERL_NET_SNMP_SITE = $(BR2_CPAN_MIRROR)/authors/id/D/DT/DTOWN
PERL_NET_SNMP_DEPENDENCIES = host-perl-module-build
PERL_NET_SNMP_LICENSE = Artistic or GPL-1.0+
PERL_NET_SNMP_LICENSE_FILES = LICENSE
PERL_NET_SNMP_DISTNAME = Net-SNMP

$(eval $(perl-package))
