################################################################################
#
# perl-http-negotiate
#
################################################################################

PERL_HTTP_NEGOTIATE_VERSION = 6.01
PERL_HTTP_NEGOTIATE_SOURCE = HTTP-Negotiate-$(PERL_HTTP_NEGOTIATE_VERSION).tar.gz
PERL_HTTP_NEGOTIATE_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GA/GAAS
PERL_HTTP_NEGOTIATE_LICENSE = Artistic or GPL-1.0+
PERL_HTTP_NEGOTIATE_LICENSE_FILES = README
PERL_HTTP_NEGOTIATE_DISTNAME = HTTP-Negotiate

$(eval $(perl-package))
