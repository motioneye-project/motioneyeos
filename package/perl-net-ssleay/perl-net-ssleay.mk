################################################################################
#
# perl-net-ssleay
#
################################################################################

PERL_NET_SSLEAY_VERSION = 1.64
PERL_NET_SSLEAY_SOURCE = Net-SSLeay-$(PERL_NET_SSLEAY_VERSION).tar.gz
PERL_NET_SSLEAY_SITE = $(BR2_CPAN_MIRROR)/authors/id/M/MI/MIKEM/
PERL_NET_SSLEAY_DEPENDENCIES = perl openssl
PERL_NET_SSLEAY_LICENSE = OpenSSL
PERL_NET_SSLEAY_LICENSE_FILES = LICENSE

$(eval $(perl-package))
