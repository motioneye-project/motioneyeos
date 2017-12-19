################################################################################
#
# perl-file-listing
#
################################################################################

PERL_FILE_LISTING_VERSION = 6.04
PERL_FILE_LISTING_SOURCE = File-Listing-$(PERL_FILE_LISTING_VERSION).tar.gz
PERL_FILE_LISTING_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GA/GAAS
PERL_FILE_LISTING_DEPENDENCIES = perl-http-date
PERL_FILE_LISTING_LICENSE = Artistic or GPL-1.0+
PERL_FILE_LISTING_LICENSE_FILES = README

$(eval $(perl-package))
