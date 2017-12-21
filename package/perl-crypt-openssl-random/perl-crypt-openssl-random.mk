################################################################################
#
# perl-crypt-openssl-random
#
################################################################################

PERL_CRYPT_OPENSSL_RANDOM_VERSION = 0.11
PERL_CRYPT_OPENSSL_RANDOM_SOURCE = Crypt-OpenSSL-Random-$(PERL_CRYPT_OPENSSL_RANDOM_VERSION).tar.gz
PERL_CRYPT_OPENSSL_RANDOM_SITE = $(BR2_CPAN_MIRROR)/authors/id/R/RU/RURBAN
PERL_CRYPT_OPENSSL_RANDOM_DEPENDENCIES = openssl
PERL_CRYPT_OPENSSL_RANDOM_LICENSE = Artistic or GPL-1.0+
PERL_CRYPT_OPENSSL_RANDOM_LICENSE_FILES = LICENSE

$(eval $(perl-package))
