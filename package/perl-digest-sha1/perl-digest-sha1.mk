################################################################################
#
# perl-digest-sha1
#
################################################################################

PERL_DIGEST_SHA1_VERSION = 2.13
PERL_DIGEST_SHA1_SOURCE = Digest-SHA1-$(PERL_DIGEST_SHA1_VERSION).tar.gz
PERL_DIGEST_SHA1_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GA/GAAS
PERL_DIGEST_SHA1_LICENSE = Artistic or GPL-1.0+
PERL_DIGEST_SHA1_LICENSE_FILES = README

$(eval $(perl-package))
