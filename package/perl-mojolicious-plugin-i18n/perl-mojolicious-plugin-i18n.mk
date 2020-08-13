################################################################################
#
# perl-mojolicious-plugin-i18n
#
################################################################################

PERL_MOJOLICIOUS_PLUGIN_I18N_VERSION = 1.6
PERL_MOJOLICIOUS_PLUGIN_I18N_SOURCE = Mojolicious-Plugin-I18N-$(PERL_MOJOLICIOUS_PLUGIN_I18N_VERSION).tar.gz
PERL_MOJOLICIOUS_PLUGIN_I18N_SITE = $(BR2_CPAN_MIRROR)/authors/id/S/SH/SHARIFULN
PERL_MOJOLICIOUS_PLUGIN_I18N_DEPENDENCIES = host-perl-module-build
PERL_MOJOLICIOUS_PLUGIN_I18N_LICENSE = Artistic-2.0
PERL_MOJOLICIOUS_PLUGIN_I18N_LICENSE_FILES = README.pod
PERL_MOJOLICIOUS_PLUGIN_I18N_DISTNAME = Mojolicious-Plugin-I18N

$(eval $(perl-package))
