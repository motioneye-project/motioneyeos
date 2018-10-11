################################################################################
#
# perl-time-hires
#
################################################################################

PERL_TIME_HIRES_VERSION = 1.9758
PERL_TIME_HIRES_SOURCE = Time-HiRes-$(PERL_TIME_HIRES_VERSION).tar.gz
PERL_TIME_HIRES_SITE = $(BR2_CPAN_MIRROR)/authors/id/J/JH/JHI
PERL_TIME_HIRES_LICENSE = Artistic or GPL-1.0+
PERL_TIME_HIRES_LICENSE_FILES = README
PERL_TIME_HIRES_DISTNAME = Time-HiRes

$(eval $(perl-package))
