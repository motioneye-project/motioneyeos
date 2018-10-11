################################################################################
#
# perl-module-implementation
#
################################################################################

PERL_MODULE_IMPLEMENTATION_VERSION = 0.09
PERL_MODULE_IMPLEMENTATION_SOURCE = Module-Implementation-$(PERL_MODULE_IMPLEMENTATION_VERSION).tar.gz
PERL_MODULE_IMPLEMENTATION_SITE = $(BR2_CPAN_MIRROR)/authors/id/D/DR/DROLSKY
PERL_MODULE_IMPLEMENTATION_LICENSE = Artistic-2.0
PERL_MODULE_IMPLEMENTATION_LICENSE_FILES = LICENSE
PERL_MODULE_IMPLEMENTATION_DISTNAME = Module-Implementation

$(eval $(perl-package))
