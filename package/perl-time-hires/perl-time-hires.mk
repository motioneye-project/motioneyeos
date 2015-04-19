################################################################################
#
# perl-time-hires
#
################################################################################

PERL_TIME_HIRES_VERSION = 1.9726
PERL_TIME_HIRES_SOURCE = Time-HiRes-$(PERL_TIME_HIRES_VERSION).tar.gz
PERL_TIME_HIRES_SITE = $(BR2_CPAN_MIRROR)/authors/id/Z/ZE/ZEFRAM
PERL_TIME_HIRES_DEPENDENCIES = perl
PERL_TIME_HIRES_LICENSE = Artistic or GPLv1+
PERL_TIME_HIRES_LICENSE_FILES = README

$(eval $(perl-package))
