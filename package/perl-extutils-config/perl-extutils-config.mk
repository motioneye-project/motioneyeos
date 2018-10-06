################################################################################
#
# perl-extutils-config
#
################################################################################

PERL_EXTUTILS_CONFIG_VERSION = 0.008
PERL_EXTUTILS_CONFIG_SOURCE = ExtUtils-Config-$(PERL_EXTUTILS_CONFIG_VERSION).tar.gz
PERL_EXTUTILS_CONFIG_SITE = $(BR2_CPAN_MIRROR)/authors/id/L/LE/LEONT
PERL_EXTUTILS_CONFIG_LICENSE = Artistic or GPL-1.0+
PERL_EXTUTILS_CONFIG_LICENSE_FILES = LICENSE

$(eval $(host-perl-package))
