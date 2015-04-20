################################################################################
#
# perl-libwww
#
################################################################################

PERL_LIBWWW_VERSION = 6.13
PERL_LIBWWW_SITE = $(call github,libwww-perl,libwww-perl,$(PERL_LIBWWW_VERSION))
PERL_LIBWWW_LICENSE = Artistic or GPLv1+
PERL_LIBWWW_LICENSE_FILES = README
PERL_LIBWWW_DEPENDENCIES = \
	perl-encode-locale \
	perl-file-listing \
	perl-html-parser \
	perl-http-cookies \
	perl-http-daemon \
	perl-http-date \
	perl-http-negotiate \
	perl-net-http \
	perl-uri \
	perl-www-robotrules

$(eval $(perl-package))
