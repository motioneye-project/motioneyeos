################################################################################
#
# perl-file-slurp
#
################################################################################

PERL_FILE_SLURP_VERSION = 9999.25
PERL_FILE_SLURP_SOURCE = File-Slurp-$(PERL_FILE_SLURP_VERSION).tar.gz
PERL_FILE_SLURP_SITE = $(BR2_CPAN_MIRROR)/authors/id/C/CA/CAPOEIRAB
PERL_FILE_SLURP_LICENSE = Artistic or GPL-1.0+
PERL_FILE_SLURP_LICENSE_FILES = README.md
PERL_FILE_SLURP_DISTNAME = File-Slurp

$(eval $(perl-package))
