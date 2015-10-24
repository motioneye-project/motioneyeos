################################################################################
#
# perl-http-message
#
################################################################################

PERL_HTTP_MESSAGE_VERSION = 6.11
PERL_HTTP_MESSAGE_SOURCE = HTTP-Message-$(PERL_HTTP_MESSAGE_VERSION).tar.gz
PERL_HTTP_MESSAGE_SITE = $(BR2_CPAN_MIRROR)/authors/id/E/ET/ETHER
PERL_HTTP_MESSAGE_DEPENDENCIES = perl-encode-locale perl-http-date perl-io-html perl-lwp-mediatypes perl-uri
PERL_HTTP_MESSAGE_LICENSE = Artistic or GPLv1+
PERL_HTTP_MESSAGE_LICENSE_FILES = LICENSE

$(eval $(perl-package))
