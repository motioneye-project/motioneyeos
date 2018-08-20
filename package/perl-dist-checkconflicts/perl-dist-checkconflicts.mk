################################################################################
#
# perl-dist-checkconflicts
#
################################################################################

PERL_DIST_CHECKCONFLICTS_VERSION = 0.11
PERL_DIST_CHECKCONFLICTS_SOURCE = Dist-CheckConflicts-$(PERL_DIST_CHECKCONFLICTS_VERSION).tar.gz
PERL_DIST_CHECKCONFLICTS_SITE = $(BR2_CPAN_MIRROR)/authors/id/D/DO/DOY
PERL_DIST_CHECKCONFLICTS_DEPENDENCIES = perl-module-runtime
PERL_DIST_CHECKCONFLICTS_LICENSE = Artistic or GPL-1.0+
PERL_DIST_CHECKCONFLICTS_LICENSE_FILES = LICENSE

$(eval $(perl-package))
