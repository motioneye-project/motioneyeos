################################################################################
#
# perl-data-dump
#
################################################################################

PERL_DATA_DUMP_VERSION = 1.23
PERL_DATA_DUMP_SOURCE = Data-Dump-$(PERL_DATA_DUMP_VERSION).tar.gz
PERL_DATA_DUMP_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GA/GAAS
PERL_DATA_DUMP_LICENSE = Artistic or GPL-1.0+
PERL_DATA_DUMP_LICENSE_FILES = README
PERL_DATA_DUMP_DISTNAME = Data-Dump

$(eval $(perl-package))
