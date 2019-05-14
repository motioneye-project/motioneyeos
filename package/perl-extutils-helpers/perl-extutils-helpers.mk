################################################################################
#
# perl-extutils-helpers
#
################################################################################

PERL_EXTUTILS_HELPERS_VERSION = 0.026
PERL_EXTUTILS_HELPERS_SOURCE = ExtUtils-Helpers-$(PERL_EXTUTILS_HELPERS_VERSION).tar.gz
PERL_EXTUTILS_HELPERS_SITE = $(BR2_CPAN_MIRROR)/authors/id/L/LE/LEONT
PERL_EXTUTILS_HELPERS_LICENSE = Artistic or GPL-1.0+
PERL_EXTUTILS_HELPERS_LICENSE_FILES = LICENSE
PERL_EXTUTILS_HELPERS_DISTNAME = ExtUtils-Helpers

$(eval $(host-perl-package))
