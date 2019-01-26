################################################################################
#
# perl-package-stash
#
################################################################################

PERL_PACKAGE_STASH_VERSION = 0.38
PERL_PACKAGE_STASH_SOURCE = Package-Stash-$(PERL_PACKAGE_STASH_VERSION).tar.gz
PERL_PACKAGE_STASH_SITE = $(BR2_CPAN_MIRROR)/authors/id/E/ET/ETHER
PERL_PACKAGE_STASH_LICENSE = Artistic or GPL-1.0+
PERL_PACKAGE_STASH_LICENSE_FILES = LICENSE
PERL_PACKAGE_STASH_DISTNAME = Package-Stash

$(eval $(perl-package))
