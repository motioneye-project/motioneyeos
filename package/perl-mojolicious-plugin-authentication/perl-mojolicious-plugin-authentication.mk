################################################################################
#
# perl-mojolicious-plugin-authentication
#
################################################################################

PERL_MOJOLICIOUS_PLUGIN_AUTHENTICATION_VERSION = 1.33
PERL_MOJOLICIOUS_PLUGIN_AUTHENTICATION_SOURCE = Mojolicious-Plugin-Authentication-$(PERL_MOJOLICIOUS_PLUGIN_AUTHENTICATION_VERSION).tar.gz
PERL_MOJOLICIOUS_PLUGIN_AUTHENTICATION_SITE = $(BR2_CPAN_MIRROR)/authors/id/J/JJ/JJATRIA
PERL_MOJOLICIOUS_PLUGIN_AUTHENTICATION_LICENSE = Artistic or GPL-1.0+
PERL_MOJOLICIOUS_PLUGIN_AUTHENTICATION_LICENSE_FILES = LICENSE
PERL_MOJOLICIOUS_PLUGIN_AUTHENTICATION_DISTNAME = Mojolicious-Plugin-Authentication

$(eval $(perl-package))
