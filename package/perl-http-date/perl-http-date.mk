################################################################################
#
# perl-http-date
#
################################################################################

PERL_HTTP_DATE_VERSION = 6.05
PERL_HTTP_DATE_SOURCE = HTTP-Date-$(PERL_HTTP_DATE_VERSION).tar.gz
PERL_HTTP_DATE_SITE = $(BR2_CPAN_MIRROR)/authors/id/O/OA/OALDERS
PERL_HTTP_DATE_LICENSE = Artistic or GPL-1.0+
PERL_HTTP_DATE_LICENSE_FILES = LICENSE
PERL_HTTP_DATE_DISTNAME = HTTP-Date

$(eval $(perl-package))
