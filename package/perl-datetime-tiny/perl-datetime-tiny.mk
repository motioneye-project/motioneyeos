################################################################################
#
# perl-datetime-tiny
#
################################################################################

PERL_DATETIME_TINY_VERSION = 1.06
PERL_DATETIME_TINY_SOURCE = DateTime-Tiny-$(PERL_DATETIME_TINY_VERSION).tar.gz
PERL_DATETIME_TINY_SITE = $(BR2_CPAN_MIRROR)/authors/id/D/DA/DAGOLDEN
PERL_DATETIME_TINY_LICENSE = Artistic or GPL-1.0+
PERL_DATETIME_TINY_LICENSE_FILES = LICENSE

$(eval $(perl-package))
