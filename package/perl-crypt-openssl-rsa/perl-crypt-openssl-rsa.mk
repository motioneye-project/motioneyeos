################################################################################
#
# perl-crypt-openssl-rsa
#
################################################################################

PERL_CRYPT_OPENSSL_RSA_VERSION = 0.31
PERL_CRYPT_OPENSSL_RSA_SOURCE = Crypt-OpenSSL-RSA-$(PERL_CRYPT_OPENSSL_RSA_VERSION).tar.gz
PERL_CRYPT_OPENSSL_RSA_SITE = $(BR2_CPAN_MIRROR)/authors/id/T/TO/TODDR
PERL_CRYPT_OPENSSL_RSA_DEPENDENCIES = \
	host-perl-crypt-openssl-guess \
	perl-crypt-openssl-random
PERL_CRYPT_OPENSSL_RSA_LICENSE = Artistic or GPL-1.0+
PERL_CRYPT_OPENSSL_RSA_LICENSE_FILES = LICENSE
PERL_CRYPT_OPENSSL_RSA_DISTNAME = Crypt-OpenSSL-RSA

# Try as hard as possible to remedy to the brain-damage their build-system
# suffers from: don't search for openssl, they pick the host-system one.
PERL_CRYPT_OPENSSL_RSA_CONF_ENV = OPENSSL_PREFIX=$(STAGING_DIR)/usr

$(eval $(perl-package))
