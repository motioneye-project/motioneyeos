################################################################################
#
# perl-class-std
#
################################################################################

PERL_CLASS_STD_VERSION = 0.013
PERL_CLASS_STD_SOURCE = Class-Std-$(PERL_CLASS_STD_VERSION).tar.gz
PERL_CLASS_STD_SITE = $(BR2_CPAN_MIRROR)/authors/id/C/CH/CHORNY
PERL_CLASS_STD_DEPENDENCIES = host-perl-module-build
PERL_CLASS_STD_LICENSE = Artistic or GPL-1.0+
PERL_CLASS_STD_LICENSE_FILES = README
PERL_CLASS_STD_DISTNAME = Class-Std

$(eval $(perl-package))
