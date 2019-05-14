################################################################################
#
# perl-digest-md5
#
################################################################################

PERL_DIGEST_MD5_VERSION = 2.55
PERL_DIGEST_MD5_SOURCE = Digest-MD5-$(PERL_DIGEST_MD5_VERSION).tar.gz
PERL_DIGEST_MD5_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GA/GAAS
PERL_DIGEST_MD5_LICENSE = Artistic or GPL-1.0+
PERL_DIGEST_MD5_LICENSE_FILES = README
PERL_DIGEST_MD5_DISTNAME = Digest-MD5

$(eval $(perl-package))
