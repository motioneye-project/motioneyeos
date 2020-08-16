################################################################################
#
# perl-mojolicious-plugin-securityheader
#
################################################################################

PERL_MOJOLICIOUS_PLUGIN_SECURITYHEADER_VERSION = 0.07
PERL_MOJOLICIOUS_PLUGIN_SECURITYHEADER_SOURCE = Mojolicious-Plugin-SecurityHeader-$(PERL_MOJOLICIOUS_PLUGIN_SECURITYHEADER_VERSION).tar.gz
PERL_MOJOLICIOUS_PLUGIN_SECURITYHEADER_SITE = $(BR2_CPAN_MIRROR)/authors/id/R/RE/RENEEB
PERL_MOJOLICIOUS_PLUGIN_SECURITYHEADER_LICENSE = Artistic-2.0
PERL_MOJOLICIOUS_PLUGIN_SECURITYHEADER_LICENSE_FILES = LICENSE
PERL_MOJOLICIOUS_PLUGIN_SECURITYHEADER_DISTNAME = Mojolicious-Plugin-SecurityHeader

$(eval $(perl-package))
