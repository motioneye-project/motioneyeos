################################################################################
#
# perl-encode-locale
#
################################################################################

PERL_ENCODE_LOCALE_VERSION = 1.05
PERL_ENCODE_LOCALE_SOURCE = Encode-Locale-$(PERL_ENCODE_LOCALE_VERSION).tar.gz
PERL_ENCODE_LOCALE_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GA/GAAS
PERL_ENCODE_LOCALE_LICENSE = Artistic or GPL-1.0+
PERL_ENCODE_LOCALE_LICENSE_FILES = README
PERL_ENCODE_LOCALE_DISTNAME = Encode-Locale

$(eval $(perl-package))
