################################################################################
#
# perl-moo
#
################################################################################

PERL_MOO_VERSION = 2.003006
PERL_MOO_SOURCE = Moo-$(PERL_MOO_VERSION).tar.gz
PERL_MOO_SITE = $(BR2_CPAN_MIRROR)/authors/id/H/HA/HAARG
PERL_MOO_LICENSE = Artistic or GPL-1.0+
PERL_MOO_LICENSE_FILES = LICENSE
PERL_MOO_DISTNAME = Moo

$(eval $(perl-package))
