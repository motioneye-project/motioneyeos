################################################################################
#
# perl-dbi
#
################################################################################

PERL_DBI_VERSION = 1.642
PERL_DBI_SOURCE = DBI-$(PERL_DBI_VERSION).tar.gz
PERL_DBI_SITE = $(BR2_CPAN_MIRROR)/authors/id/T/TI/TIMB
PERL_DBI_LICENSE = Artistic or GPL-1.0+
PERL_DBI_LICENSE_FILES = LICENSE
PERL_DBI_DISTNAME = DBI

$(eval $(perl-package))
$(eval $(host-perl-package))
