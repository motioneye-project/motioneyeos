################################################################################
#
# perl-net-http
#
################################################################################

PERL_NET_HTTP_VERSION = 6.18
PERL_NET_HTTP_SOURCE = Net-HTTP-$(PERL_NET_HTTP_VERSION).tar.gz
PERL_NET_HTTP_SITE = $(BR2_CPAN_MIRROR)/authors/id/O/OA/OALDERS
PERL_NET_HTTP_LICENSE = Artistic or GPL-1.0+
PERL_NET_HTTP_LICENSE_FILES = LICENSE
PERL_NET_HTTP_DISTNAME = Net-HTTP

$(eval $(perl-package))
