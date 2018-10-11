################################################################################
#
# perl-time-parsedate
#
################################################################################

PERL_TIME_PARSEDATE_VERSION = 2015.103
PERL_TIME_PARSEDATE_SOURCE = Time-ParseDate-$(PERL_TIME_PARSEDATE_VERSION).tar.gz
PERL_TIME_PARSEDATE_SITE = $(BR2_CPAN_MIRROR)/authors/id/M/MU/MUIR/modules
PERL_TIME_PARSEDATE_LICENSE = Time Parse Date License, Public Domain
PERL_TIME_PARSEDATE_LICENSE_FILES = lib/Time/JulianDay.pm lib/Time/Timezone.pm
PERL_TIME_PARSEDATE_DISTNAME = Time-ParseDate

$(eval $(perl-package))
