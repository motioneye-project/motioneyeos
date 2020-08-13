################################################################################
#
# perl-http-headers-fast
#
################################################################################

PERL_HTTP_HEADERS_FAST_VERSION = 0.22
PERL_HTTP_HEADERS_FAST_SOURCE = HTTP-Headers-Fast-$(PERL_HTTP_HEADERS_FAST_VERSION).tar.gz
PERL_HTTP_HEADERS_FAST_SITE = $(BR2_CPAN_MIRROR)/authors/id/T/TO/TOKUHIROM
PERL_HTTP_HEADERS_FAST_DEPENDENCIES = host-perl-module-build-tiny
PERL_HTTP_HEADERS_FAST_LICENSE = Artistic or GPL-1.0+
PERL_HTTP_HEADERS_FAST_LICENSE_FILES = LICENSE
PERL_HTTP_HEADERS_FAST_DISTNAME = HTTP-Headers-Fast

$(eval $(perl-package))
