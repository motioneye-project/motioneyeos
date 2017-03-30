################################################################################
#
# perl-http-cookies
#
################################################################################

PERL_HTTP_COOKIES_VERSION = 6.01
PERL_HTTP_COOKIES_SOURCE = HTTP-Cookies-$(PERL_HTTP_COOKIES_VERSION).tar.gz
PERL_HTTP_COOKIES_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GA/GAAS
PERL_HTTP_COOKIES_DEPENDENCIES = perl-http-date perl-http-message
PERL_HTTP_COOKIES_LICENSE = Artistic or GPL-1.0+
PERL_HTTP_COOKIES_LICENSE_FILES = README

$(eval $(perl-package))
