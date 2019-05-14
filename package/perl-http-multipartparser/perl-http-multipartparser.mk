################################################################################
#
# perl-http-multipartparser
#
################################################################################

PERL_HTTP_MULTIPARTPARSER_VERSION = 0.02
PERL_HTTP_MULTIPARTPARSER_SOURCE = HTTP-MultiPartParser-$(PERL_HTTP_MULTIPARTPARSER_VERSION).tar.gz
PERL_HTTP_MULTIPARTPARSER_SITE = $(BR2_CPAN_MIRROR)/authors/id/C/CH/CHANSEN
PERL_HTTP_MULTIPARTPARSER_LICENSE = Artistic or GPL-1.0+
PERL_HTTP_MULTIPARTPARSER_LICENSE_FILES = README
PERL_HTTP_MULTIPARTPARSER_DISTNAME = HTTP-MultiPartParser

$(eval $(perl-package))
