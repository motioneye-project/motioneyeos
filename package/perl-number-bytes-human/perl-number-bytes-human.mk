################################################################################
#
# perl-number-bytes-human
#
################################################################################

PERL_NUMBER_BYTES_HUMAN_VERSION = 0.11
PERL_NUMBER_BYTES_HUMAN_SOURCE = Number-Bytes-Human-$(PERL_NUMBER_BYTES_HUMAN_VERSION).tar.gz
PERL_NUMBER_BYTES_HUMAN_SITE = $(BR2_CPAN_MIRROR)/authors/id/F/FE/FERREIRA
PERL_NUMBER_BYTES_HUMAN_LICENSE = Artistic or GPL-1.0+
PERL_NUMBER_BYTES_HUMAN_LICENSE_FILES = README
PERL_NUMBER_BYTES_HUMAN_DISTNAME = Number-Bytes-Human

$(eval $(perl-package))
