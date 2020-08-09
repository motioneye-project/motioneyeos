################################################################################
#
# perl-path-class
#
################################################################################

PERL_PATH_CLASS_VERSION = 0.37
PERL_PATH_CLASS_SOURCE = Path-Class-$(PERL_PATH_CLASS_VERSION).tar.gz
PERL_PATH_CLASS_SITE = $(BR2_CPAN_MIRROR)/authors/id/K/KW/KWILLIAMS
HOST_PERL_PATH_CLASS_DEPENDENCIES = host-perl-module-build
PERL_PATH_CLASS_LICENSE = Artistic or GPL-1.0+
PERL_PATH_CLASS_LICENSE_FILES = LICENSE
PERL_PATH_CLASS_DISTNAME = Path-Class

$(eval $(host-perl-package))
