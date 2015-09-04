################################################################################
#
# perl-lwp-mediatypes
#
################################################################################

PERL_LWP_MEDIATYPES_VERSION = 6.02
PERL_LWP_MEDIATYPES_SOURCE = LWP-MediaTypes-$(PERL_LWP_MEDIATYPES_VERSION).tar.gz
PERL_LWP_MEDIATYPES_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GA/GAAS
PERL_LWP_MEDIATYPES_LICENSE = Artistic or GPLv1+
PERL_LWP_MEDIATYPES_LICENSE_FILES = README

$(eval $(perl-package))
