################################################################################
#
# perl-http-message
#
################################################################################

PERL_HTTP_MESSAGE_VERSION = 6.06
PERL_HTTP_MESSAGE_SOURCE = HTTP-Message-$(PERL_HTTP_MESSAGE_VERSION).tar.gz
PERL_HTTP_MESSAGE_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GA/GAAS
PERL_HTTP_MESSAGE_LICENSE = Artistic or GPLv1+
PERL_HTTP_MESSAGE_LICENSE_FILES = README
PERL_HTTP_MESSAGE_DEPENDENCIES = \
	perl-encode-locale \
	perl-http-date \
	perl-io-html \
	perl-lwp-mediatypes \
	perl-uri

$(eval $(perl-package))
