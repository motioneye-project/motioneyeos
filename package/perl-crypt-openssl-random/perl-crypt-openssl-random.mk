################################################################################
#
# perl-crypt-openssl-random
#
################################################################################

PERL_CRYPT_OPENSSL_RANDOM_VERSION = 0.15
PERL_CRYPT_OPENSSL_RANDOM_SOURCE = Crypt-OpenSSL-Random-$(PERL_CRYPT_OPENSSL_RANDOM_VERSION).tar.gz
PERL_CRYPT_OPENSSL_RANDOM_SITE = $(BR2_CPAN_MIRROR)/authors/id/R/RU/RURBAN
PERL_CRYPT_OPENSSL_RANDOM_DEPENDENCIES = \
	host-perl-crypt-openssl-guess \
	openssl
PERL_CRYPT_OPENSSL_RANDOM_LICENSE = Artistic or GPL-1.0+
PERL_CRYPT_OPENSSL_RANDOM_LICENSE_FILES = LICENSE
PERL_CRYPT_OPENSSL_RANDOM_DISTNAME = Crypt-OpenSSL-Random

# Try as hard as possible to remedy to the brain-damage their build-system
# suffers from: don't search for openssl, they pick the host-system one.
PERL_CRYPT_OPENSSL_RANDOM_CONF_ENV = OPENSSL_PREFIX=$(STAGING_DIR)/usr

$(eval $(perl-package))
