################################################################################
#
# perl-locale-maketext-lexicon
#
################################################################################

PERL_LOCALE_MAKETEXT_LEXICON_VERSION = 1.00
PERL_LOCALE_MAKETEXT_LEXICON_SOURCE = Locale-Maketext-Lexicon-$(PERL_LOCALE_MAKETEXT_LEXICON_VERSION).tar.gz
PERL_LOCALE_MAKETEXT_LEXICON_SITE = $(BR2_CPAN_MIRROR)/authors/id/D/DR/DRTECH
PERL_LOCALE_MAKETEXT_LEXICON_LICENSE = MIT
PERL_LOCALE_MAKETEXT_LEXICON_LICENSE_FILES = LICENSE
PERL_LOCALE_MAKETEXT_LEXICON_DISTNAME = Locale-Maketext-Lexicon

$(eval $(perl-package))
