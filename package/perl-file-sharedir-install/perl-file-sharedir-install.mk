################################################################################
#
# perl-file-sharedir-install
#
################################################################################

PERL_FILE_SHAREDIR_INSTALL_VERSION = 0.13
PERL_FILE_SHAREDIR_INSTALL_SOURCE = File-ShareDir-Install-$(PERL_FILE_SHAREDIR_INSTALL_VERSION).tar.gz
PERL_FILE_SHAREDIR_INSTALL_SITE = $(BR2_CPAN_MIRROR)/authors/id/E/ET/ETHER
PERL_FILE_SHAREDIR_INSTALL_LICENSE = Artistic or GPL-1.0+
PERL_FILE_SHAREDIR_INSTALL_LICENSE_FILES = LICENSE
PERL_FILE_SHAREDIR_INSTALL_DISTNAME = File-ShareDir-Install

$(eval $(host-perl-package))
