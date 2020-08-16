################################################################################
#
# perl-mojolicious-plugin-cspheader
#
################################################################################

PERL_MOJOLICIOUS_PLUGIN_CSPHEADER_VERSION = 0.06
PERL_MOJOLICIOUS_PLUGIN_CSPHEADER_SOURCE = Mojolicious-Plugin-CSPHeader-$(PERL_MOJOLICIOUS_PLUGIN_CSPHEADER_VERSION).tar.gz
PERL_MOJOLICIOUS_PLUGIN_CSPHEADER_SITE = $(BR2_CPAN_MIRROR)/authors/id/L/LD/LDIDRY
PERL_MOJOLICIOUS_PLUGIN_CSPHEADER_LICENSE = Artistic or GPL-1.0+
PERL_MOJOLICIOUS_PLUGIN_CSPHEADER_LICENSE_FILES = LICENSE
PERL_MOJOLICIOUS_PLUGIN_CSPHEADER_DISTNAME = Mojolicious-Plugin-CSPHeader

$(eval $(perl-package))
