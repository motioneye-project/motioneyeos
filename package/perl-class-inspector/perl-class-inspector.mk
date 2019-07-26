################################################################################
#
# perl-class-inspector
#
################################################################################

PERL_CLASS_INSPECTOR_VERSION = 1.36
PERL_CLASS_INSPECTOR_SOURCE = Class-Inspector-$(PERL_CLASS_INSPECTOR_VERSION).tar.gz
PERL_CLASS_INSPECTOR_SITE = $(BR2_CPAN_MIRROR)/authors/id/P/PL/PLICEASE
PERL_CLASS_INSPECTOR_LICENSE = Artistic or GPL-1.0+
PERL_CLASS_INSPECTOR_LICENSE_FILES = LICENSE
PERL_CLASS_INSPECTOR_DISTNAME = Class-Inspector

$(eval $(perl-package))
