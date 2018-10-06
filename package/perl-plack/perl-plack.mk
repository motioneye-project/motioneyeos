################################################################################
#
# perl-plack
#
################################################################################

PERL_PLACK_VERSION = 1.0047
PERL_PLACK_SOURCE = Plack-$(PERL_PLACK_VERSION).tar.gz
PERL_PLACK_SITE = $(BR2_CPAN_MIRROR)/authors/id/M/MI/MIYAGAWA
PERL_PLACK_DEPENDENCIES = \
	host-perl-file-sharedir-install \
	perl-apache-logformat-compiler \
	perl-cookie-baker \
	perl-devel-stacktrace \
	perl-devel-stacktrace-ashtml \
	perl-file-sharedir \
	perl-filesys-notify-simple \
	perl-http-entity-parser \
	perl-http-headers-fast \
	perl-http-message \
	perl-hash-multivalue \
	perl-stream-buffered \
	perl-try-tiny perl-uri \
	perl-www-form-urlencoded
PERL_PLACK_LICENSE = Artistic or GPL-1.0+
PERL_PLACK_LICENSE_FILES = LICENSE

$(eval $(perl-package))
