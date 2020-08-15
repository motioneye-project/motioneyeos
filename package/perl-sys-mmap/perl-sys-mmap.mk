################################################################################
#
# perl-sys-mmap
#
################################################################################

PERL_SYS_MMAP_VERSION = 0.20
PERL_SYS_MMAP_SOURCE = Sys-Mmap-$(PERL_SYS_MMAP_VERSION).tar.gz
PERL_SYS_MMAP_SITE = $(BR2_CPAN_MIRROR)/authors/id/T/TO/TODDR
PERL_SYS_MMAP_LICENSE = Artistic or GPL-1.0+
PERL_SYS_MMAP_LICENSE_FILES = Artistic Copying
PERL_SYS_MMAP_DISTNAME = Sys-Mmap

$(eval $(perl-package))
