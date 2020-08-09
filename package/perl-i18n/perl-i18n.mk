################################################################################
#
# perl-i18n
#
################################################################################

PERL_I18N_VERSION = 0.13
PERL_I18N_SOURCE = i18n-$(PERL_I18N_VERSION).tar.gz
PERL_I18N_SITE = $(BR2_CPAN_MIRROR)/authors/id/A/AU/AUDREYT
PERL_I18N_LICENSE = MIT
PERL_I18N_LICENSE_FILES = README
PERL_I18N_DISTNAME = i18n

$(eval $(perl-package))
