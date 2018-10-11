################################################################################
#
# perl-astro-suntime
#
################################################################################

PERL_ASTRO_SUNTIME_VERSION = 0.06
PERL_ASTRO_SUNTIME_SOURCE = Astro-SunTime-$(PERL_ASTRO_SUNTIME_VERSION).tar.gz
PERL_ASTRO_SUNTIME_SITE = $(BR2_CPAN_MIRROR)/authors/id/R/RO/ROBF
PERL_ASTRO_SUNTIME_DEPENDENCIES = host-perl-module-build
PERL_ASTRO_SUNTIME_LICENSE = GPL-3.0
PERL_ASTRO_SUNTIME_LICENSE_FILES = LICENSE
PERL_ASTRO_SUNTIME_DISTNAME = Astro-SunTime

$(eval $(perl-package))
