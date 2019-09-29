################################################################################
#
# perl-crypt-openssl-guess
#
################################################################################

PERL_CRYPT_OPENSSL_GUESS_VERSION = 0.11
PERL_CRYPT_OPENSSL_GUESS_SOURCE = Crypt-OpenSSL-Guess-$(PERL_CRYPT_OPENSSL_GUESS_VERSION).tar.gz
PERL_CRYPT_OPENSSL_GUESS_SITE = $(BR2_CPAN_MIRROR)/authors/id/A/AK/AKIYM
PERL_CRYPT_OPENSSL_GUESS_LICENSE = Artistic or GPL-1.0+
PERL_CRYPT_OPENSSL_GUESS_LICENSE_FILES = LICENSE
PERL_CRYPT_OPENSSL_GUESS_DISTNAME = Crypt-OpenSSL-Guess

$(eval $(host-perl-package))
