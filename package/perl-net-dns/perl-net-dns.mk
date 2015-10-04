################################################################################
#
# perl-net-dns
#
################################################################################

PERL_NET_DNS_VERSION = 0.83
PERL_NET_DNS_SOURCE = Net-DNS-$(PERL_NET_DNS_VERSION).tar.gz
PERL_NET_DNS_SITE = $(BR2_CPAN_MIRROR)/authors/id/N/NL/NLNETLABS
PERL_NET_DNS_DEPENDENCIES = perl perl-digest-hmac
PERL_NET_DNS_LICENSE = Artistic or GPLv1+
PERL_NET_DNS_LICENSE_FILES = README

$(eval $(perl-package))
