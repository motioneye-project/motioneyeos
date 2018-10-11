################################################################################
#
# perl-file-sharedir
#
################################################################################

PERL_FILE_SHAREDIR_VERSION = 1.116
PERL_FILE_SHAREDIR_SOURCE = File-ShareDir-$(PERL_FILE_SHAREDIR_VERSION).tar.gz
PERL_FILE_SHAREDIR_SITE = $(BR2_CPAN_MIRROR)/authors/id/R/RE/REHSACK
PERL_FILE_SHAREDIR_DEPENDENCIES = host-perl-file-sharedir-install
PERL_FILE_SHAREDIR_LICENSE = Artistic or GPL-1.0+
PERL_FILE_SHAREDIR_LICENSE_FILES = LICENSE
PERL_FILE_SHAREDIR_DISTNAME = File-ShareDir

$(eval $(perl-package))
