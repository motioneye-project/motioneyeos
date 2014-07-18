################################################################################
#
# perl-gdtextutil
#
################################################################################

PERL_GDTEXTUTIL_VERSION = 0.86
PERL_GDTEXTUTIL_SOURCE = GDTextUtil-$(PERL_GDTEXTUTIL_VERSION).tar.gz
PERL_GDTEXTUTIL_SITE = $(BR2_CPAN_MIRROR)/authors/id/M/MV/MVERB/
PERL_GDTEXTUTIL_DEPENDENCIES = perl
PERL_GDTEXTUTIL_LICENSE_FILES = Dustismo.LICENSE

$(eval $(perl-package))
