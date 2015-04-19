################################################################################
#
# perl-uri
#
################################################################################

PERL_URI_VERSION = 1.67
PERL_URI_SOURCE = URI-$(PERL_URI_VERSION).tar.gz
PERL_URI_SITE = $(BR2_CPAN_MIRROR)/authors/id/E/ET/ETHER
PERL_URI_DEPENDENCIES = perl
PERL_URI_LICENSE = Artistic or GPLv1+
PERL_URI_LICENSE_FILES = README

$(eval $(perl-package))
