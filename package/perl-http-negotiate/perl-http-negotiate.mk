################################################################################
#
# perl-http-negotiate
#
################################################################################

PERL_HTTP_NEGOTIATE_VERSION = 6.01
PERL_HTTP_NEGOTIATE_SOURCE = HTTP-Negotiate-$(PERL_HTTP_NEGOTIATE_VERSION).tar.gz
PERL_HTTP_NEGOTIATE_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GA/GAAS
PERL_HTTP_NEGOTIATE_DEPENDENCIES = perl-http-message
PERL_HTTP_NEGOTIATE_LICENSE = Artistic or GPLv1+
PERL_HTTP_NEGOTIATE_LICENSE_FILES = README

$(eval $(perl-package))
