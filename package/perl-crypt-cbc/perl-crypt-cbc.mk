################################################################################
#
# perl-crypt-cbc
#
################################################################################

PERL_CRYPT_CBC_VERSION = 2.33
PERL_CRYPT_CBC_SOURCE = Crypt-CBC-$(PERL_CRYPT_CBC_VERSION).tar.gz
PERL_CRYPT_CBC_SITE = $(BR2_CPAN_MIRROR)/authors/id/L/LD/LDS
PERL_CRYPT_CBC_LICENSE = Artistic
PERL_CRYPT_CBC_LICENSE_FILES = CBC.pm
PERL_CRYPT_CBC_DISTNAME = Crypt-CBC

$(eval $(perl-package))
