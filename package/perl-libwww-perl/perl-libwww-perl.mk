################################################################################
#
# perl-libwww-perl
#
################################################################################

PERL_LIBWWW_PERL_VERSION = 6.16
PERL_LIBWWW_PERL_SOURCE = libwww-perl-$(PERL_LIBWWW_PERL_VERSION).tar.gz
PERL_LIBWWW_PERL_SITE = $(BR2_CPAN_MIRROR)/authors/id/O/OA/OALDERS
PERL_LIBWWW_PERL_DEPENDENCIES = \
	perl-encode-locale \
	perl-file-listing \
	perl-html-parser \
	perl-http-cookies \
	perl-http-daemon \
	perl-http-date \
	perl-http-message \
	perl-http-negotiate \
	perl-lwp-mediatypes \
	perl-net-http \
	perl-uri \
	perl-www-robotrules
PERL_LIBWWW_PERL_LICENSE = Artistic or GPL-1.0+
PERL_LIBWWW_PERL_LICENSE_FILES = LICENSE

$(eval $(perl-package))
