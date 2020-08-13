################################################################################
#
# perl-crypt-openssl-aes
#
################################################################################

PERL_CRYPT_OPENSSL_AES_VERSION = 0.02
PERL_CRYPT_OPENSSL_AES_SOURCE = Crypt-OpenSSL-AES-$(PERL_CRYPT_OPENSSL_AES_VERSION).tar.gz
PERL_CRYPT_OPENSSL_AES_SITE = $(BR2_CPAN_MIRROR)/authors/id/T/TT/TTAR
PERL_CRYPT_OPENSSL_AES_LICENSE = Artistic or GPL-1.0+
PERL_CRYPT_OPENSSL_AES_LICENSE_FILES = README
PERL_CRYPT_OPENSSL_AES_DISTNAME = Crypt-OpenSSL-AES
PERL_CRYPT_OPENSSL_AES_DEPENDENCIES = openssl

$(eval $(perl-package))
