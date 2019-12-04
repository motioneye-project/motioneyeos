################################################################################
#
# perl-date-manip
#
################################################################################

PERL_DATE_MANIP_VERSION = 6.79
PERL_DATE_MANIP_SOURCE = Date-Manip-$(PERL_DATE_MANIP_VERSION).tar.gz
PERL_DATE_MANIP_SITE = $(BR2_CPAN_MIRROR)/authors/id/S/SB/SBECK
PERL_DATE_MANIP_LICENSE = Artistic or GPL-1.0+
PERL_DATE_MANIP_LICENSE_FILES = LICENSE
PERL_DATE_MANIP_DISTNAME = Date-Manip

$(eval $(perl-package))
