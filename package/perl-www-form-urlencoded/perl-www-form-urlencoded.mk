################################################################################
#
# perl-www-form-urlencoded
#
################################################################################

PERL_WWW_FORM_URLENCODED_VERSION = 0.26
PERL_WWW_FORM_URLENCODED_SOURCE = WWW-Form-UrlEncoded-$(PERL_WWW_FORM_URLENCODED_VERSION).tar.gz
PERL_WWW_FORM_URLENCODED_SITE = $(BR2_CPAN_MIRROR)/authors/id/K/KA/KAZEBURO
PERL_WWW_FORM_URLENCODED_DEPENDENCIES = host-perl-module-build
PERL_WWW_FORM_URLENCODED_LICENSE = Artistic or GPL-1.0+
PERL_WWW_FORM_URLENCODED_LICENSE_FILES = LICENSE
PERL_WWW_FORM_URLENCODED_DISTNAME = WWW-Form-UrlEncoded

$(eval $(perl-package))
