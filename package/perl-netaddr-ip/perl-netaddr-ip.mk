################################################################################
#
# perl-netaddr-ip
#
################################################################################

PERL_NETADDR_IP_VERSION = 4.078
PERL_NETADDR_IP_SOURCE = NetAddr-IP-$(PERL_NETADDR_IP_VERSION).tar.gz
PERL_NETADDR_IP_SITE = $(BR2_CPAN_MIRROR)/authors/id/M/MI/MIKER
PERL_NETADDR_IP_LICENSE = Artistic or GPLv1+
PERL_NETADDR_IP_LICENSE_FILES = Artistic Copying

# we always build the Pure Perl version.
# the build of the native part of NetAddr::IP::Util is buggy.
PERL_NETADDR_IP_CONF_OPTS = -noxs

$(eval $(perl-package))
