################################################################################
#
# perl-sub-install
#
################################################################################

PERL_SUB_INSTALL_VERSION = 0.928
PERL_SUB_INSTALL_SOURCE = Sub-Install-$(PERL_SUB_INSTALL_VERSION).tar.gz
PERL_SUB_INSTALL_SITE = $(BR2_CPAN_MIRROR)/authors/id/R/RJ/RJBS
PERL_SUB_INSTALL_LICENSE = Artistic or GPL-1.0+
PERL_SUB_INSTALL_LICENSE_FILES = LICENSE
PERL_SUB_INSTALL_DISTNAME = Sub-Install

$(eval $(perl-package))
