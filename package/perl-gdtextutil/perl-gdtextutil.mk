################################################################################
#
# perl-gdtextutil
#
################################################################################

PERL_GDTEXTUTIL_VERSION = 0.86
PERL_GDTEXTUTIL_SOURCE = GDTextUtil-$(PERL_GDTEXTUTIL_VERSION).tar.gz
PERL_GDTEXTUTIL_SITE = $(BR2_CPAN_MIRROR)/authors/id/M/MV/MVERB
PERL_GDTEXTUTIL_LICENSE = Artistic or GPL-1.0+ (perl module), GPL-2.0+ (font)
PERL_GDTEXTUTIL_LICENSE_FILES = Dustismo.LICENSE README
PERL_GDTEXTUTIL_DISTNAME = GDTextUtil

$(eval $(perl-package))
