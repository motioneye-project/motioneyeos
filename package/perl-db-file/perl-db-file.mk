################################################################################
#
# perl-db-file
#
################################################################################

PERL_DB_FILE_VERSION = 1.835
PERL_DB_FILE_SOURCE = DB_File-$(PERL_DB_FILE_VERSION).tar.gz
PERL_DB_FILE_SITE = $(BR2_CPAN_MIRROR)/authors/id/P/PM/PMQS
PERL_DB_FILE_DEPENDENCIES = berkeleydb
PERL_DB_FILE_LICENSE = Artistic or GPLv1+
PERL_DB_FILE_LICENSE_FILES = README

$(eval $(perl-package))
