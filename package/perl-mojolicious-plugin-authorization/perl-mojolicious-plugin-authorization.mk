################################################################################
#
# perl-mojolicious-plugin-authorization
#
################################################################################

PERL_MOJOLICIOUS_PLUGIN_AUTHORIZATION_VERSION = 1.05
PERL_MOJOLICIOUS_PLUGIN_AUTHORIZATION_SOURCE = Mojolicious-Plugin-Authorization-$(PERL_MOJOLICIOUS_PLUGIN_AUTHORIZATION_VERSION).tar.gz
PERL_MOJOLICIOUS_PLUGIN_AUTHORIZATION_SITE = $(BR2_CPAN_MIRROR)/authors/id/B/BY/BYTEROCK
PERL_MOJOLICIOUS_PLUGIN_AUTHORIZATION_DEPENDENCIES = host-perl-module-build
PERL_MOJOLICIOUS_PLUGIN_AUTHORIZATION_LICENSE = Artistic or GPL-1.0+
PERL_MOJOLICIOUS_PLUGIN_AUTHORIZATION_LICENSE_FILES = LICENSE
PERL_MOJOLICIOUS_PLUGIN_AUTHORIZATION_DISTNAME = Mojolicious-Plugin-Authorization

$(eval $(perl-package))
