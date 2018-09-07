################################################################################
#
# perl-date-manip
#
################################################################################

PERL_DATE_MANIP_VERSION = 6.72
PERL_DATE_MANIP_SOURCE = Date-Manip-$(PERL_DATE_MANIP_VERSION).tar.gz
PERL_DATE_MANIP_SITE = $(BR2_CPAN_MIRROR)/authors/id/S/SB/SBECK
PERL_DATE_MANIP_LICENSE = Artistic or GPL-1.0+
PERL_DATE_MANIP_LICENSE_FILES = LICENSE

$(eval $(perl-package))
