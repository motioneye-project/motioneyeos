################################################################################
#
# perl-encode-locale
#
################################################################################

PERL_ENCODE_LOCALE_VERSION = 1.05
PERL_ENCODE_LOCALE_SOURCE = Encode-Locale-$(PERL_ENCODE_LOCALE_VERSION).tar.gz
PERL_ENCODE_LOCALE_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GA/GAAS
PERL_ENCODE_LOCALE_LICENSE = Artistic or GPLv1+
PERL_ENCODE_LOCALE_LICENSE_FILES = README

$(eval $(perl-package))
