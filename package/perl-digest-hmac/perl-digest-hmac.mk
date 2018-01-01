################################################################################
#
# perl-digest-hmac
#
################################################################################

PERL_DIGEST_HMAC_VERSION = 1.03
PERL_DIGEST_HMAC_SOURCE = Digest-HMAC-$(PERL_DIGEST_HMAC_VERSION).tar.gz
PERL_DIGEST_HMAC_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GA/GAAS
PERL_DIGEST_HMAC_LICENSE = Artistic or GPL-1.0+
PERL_DIGEST_HMAC_LICENSE_FILES = README

$(eval $(perl-package))
