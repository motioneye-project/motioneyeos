################################################################################
#
# perl-crypt-openssl-rsa
#
################################################################################

PERL_CRYPT_OPENSSL_RSA_VERSION = 0.28
PERL_CRYPT_OPENSSL_RSA_SOURCE = Crypt-OpenSSL-RSA-$(PERL_CRYPT_OPENSSL_RSA_VERSION).tar.gz
PERL_CRYPT_OPENSSL_RSA_SITE = $(BR2_CPAN_MIRROR)/authors/id/P/PE/PERLER
PERL_CRYPT_OPENSSL_RSA_DEPENDENCIES = perl-crypt-openssl-random
PERL_CRYPT_OPENSSL_RSA_LICENSE = Artistic or GPLv1+
PERL_CRYPT_OPENSSL_RSA_LICENSE_FILES = LICENSE

$(eval $(perl-package))
