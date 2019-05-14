################################################################################
#
# perl-appconfig
#
################################################################################

PERL_APPCONFIG_VERSION = 1.71
PERL_APPCONFIG_SOURCE = AppConfig-$(PERL_APPCONFIG_VERSION).tar.gz
PERL_APPCONFIG_SITE = $(BR2_CPAN_MIRROR)/authors/id/N/NE/NEILB
PERL_APPCONFIG_LICENSE = Artistic or GPL-1.0+
PERL_APPCONFIG_LICENSE_FILES = LICENSE
PERL_APPCONFIG_DISTNAME = AppConfig

$(eval $(perl-package))
