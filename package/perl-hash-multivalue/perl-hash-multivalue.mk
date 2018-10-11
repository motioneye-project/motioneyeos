################################################################################
#
# perl-hash-multivalue
#
################################################################################

PERL_HASH_MULTIVALUE_VERSION = 0.16
PERL_HASH_MULTIVALUE_SOURCE = Hash-MultiValue-$(PERL_HASH_MULTIVALUE_VERSION).tar.gz
PERL_HASH_MULTIVALUE_SITE = $(BR2_CPAN_MIRROR)/authors/id/A/AR/ARISTOTLE
PERL_HASH_MULTIVALUE_LICENSE = Artistic or GPL-1.0+
PERL_HASH_MULTIVALUE_LICENSE_FILES = LICENSE
PERL_HASH_MULTIVALUE_DISTNAME = Hash-MultiValue

$(eval $(perl-package))
