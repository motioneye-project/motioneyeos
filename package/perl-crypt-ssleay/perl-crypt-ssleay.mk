################################################################################
#
# perl-crypt-ssleay
#
################################################################################

PERL_CRYPT_SSLEAY_VERSION = 0.72
PERL_CRYPT_SSLEAY_SOURCE = Crypt-SSLeay-$(PERL_CRYPT_SSLEAY_VERSION).tar.gz
PERL_CRYPT_SSLEAY_SITE = $(BR2_CPAN_MIRROR)/authors/id/N/NA/NANIS
PERL_CRYPT_SSLEAY_DEPENDENCIES = \
	openssl \
	host-perl-path-class \
	host-perl-try-tiny
PERL_CRYPT_SSLEAY_LICENSE = Artistic-2.0
PERL_CRYPT_SSLEAY_LICENSE_FILES = README.md
PERL_CRYPT_SSLEAY_DISTNAME = Crypt-SSLeay

$(eval $(perl-package))
