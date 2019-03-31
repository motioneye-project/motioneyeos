################################################################################
#
# perl-lwp-mediatypes
#
################################################################################

PERL_LWP_MEDIATYPES_VERSION = 6.04
PERL_LWP_MEDIATYPES_SOURCE = LWP-MediaTypes-$(PERL_LWP_MEDIATYPES_VERSION).tar.gz
PERL_LWP_MEDIATYPES_SITE = $(BR2_CPAN_MIRROR)/authors/id/O/OA/OALDERS
PERL_LWP_MEDIATYPES_LICENSE = Artistic or GPL-1.0+
PERL_LWP_MEDIATYPES_LICENSE_FILES = LICENSE
PERL_LWP_MEDIATYPES_DISTNAME = LWP-MediaTypes

$(eval $(perl-package))
