################################################################################
#
# perl-http-date
#
################################################################################

PERL_HTTP_DATE_VERSION = 6.02
PERL_HTTP_DATE_SOURCE = HTTP-Date-$(PERL_HTTP_DATE_VERSION).tar.gz
PERL_HTTP_DATE_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GA/GAAS
PERL_HTTP_DATE_LICENSE = Artistic or GPL-1.0+
PERL_HTTP_DATE_LICENSE_FILES = README
PERL_HTTP_DATE_DISTNAME = HTTP-Date

$(eval $(perl-package))
