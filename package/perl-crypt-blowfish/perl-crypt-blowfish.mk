################################################################################
#
# perl-crypt-blowfish
#
################################################################################

PERL_CRYPT_BLOWFISH_VERSION = 2.14
PERL_CRYPT_BLOWFISH_SOURCE = Crypt-Blowfish-$(PERL_CRYPT_BLOWFISH_VERSION).tar.gz
PERL_CRYPT_BLOWFISH_SITE = $(BR2_CPAN_MIRROR)/authors/id/D/DP/DPARIS
PERL_CRYPT_BLOWFISH_LICENSE = BSD-4-Clause-like
PERL_CRYPT_BLOWFISH_LICENSE_FILES = COPYRIGHT
PERL_CRYPT_BLOWFISH_DISTNAME = Crypt-Blowfish

$(eval $(perl-package))
