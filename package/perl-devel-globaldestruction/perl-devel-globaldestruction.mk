################################################################################
#
# perl-devel-globaldestruction
#
################################################################################

PERL_DEVEL_GLOBALDESTRUCTION_VERSION = 0.14
PERL_DEVEL_GLOBALDESTRUCTION_SOURCE = Devel-GlobalDestruction-$(PERL_DEVEL_GLOBALDESTRUCTION_VERSION).tar.gz
PERL_DEVEL_GLOBALDESTRUCTION_SITE = $(BR2_CPAN_MIRROR)/authors/id/H/HA/HAARG
PERL_DEVEL_GLOBALDESTRUCTION_LICENSE = Artistic or GPL-1.0+
PERL_DEVEL_GLOBALDESTRUCTION_LICENSE_FILES = README
PERL_DEVEL_GLOBALDESTRUCTION_DISTNAME = Devel-GlobalDestruction

$(eval $(perl-package))
