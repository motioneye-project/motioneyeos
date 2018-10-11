################################################################################
#
# perl-x10
#
################################################################################

PERL_X10_VERSION = 0.04
PERL_X10_SOURCE = X10-$(PERL_X10_VERSION).tar.gz
PERL_X10_SITE = $(BR2_CPAN_MIRROR)/authors/id/R/RO/ROBF
PERL_X10_LICENSE = GPL-3.0
PERL_X10_LICENSE_FILES = README
PERL_X10_DISTNAME = X10

$(eval $(perl-package))
