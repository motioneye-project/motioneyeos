################################################################################
#
# perl-net-http
#
################################################################################

PERL_NET_HTTP_VERSION = 6.07
PERL_NET_HTTP_SOURCE = Net-HTTP-$(PERL_NET_HTTP_VERSION).tar.gz
PERL_NET_HTTP_SITE = $(BR2_CPAN_MIRROR)/authors/id/M/MS/MSCHILLI
PERL_NET_HTTP_DEPENDENCIES = perl-uri
PERL_NET_HTTP_LICENSE = Artistic or GPLv1+
PERL_NET_HTTP_LICENSE_FILES = README

$(eval $(perl-package))
