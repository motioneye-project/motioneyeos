################################################################################
#
# perl-sys-meminfo
#
################################################################################

PERL_SYS_MEMINFO_VERSION = 0.99
PERL_SYS_MEMINFO_SOURCE = Sys-MemInfo-$(PERL_SYS_MEMINFO_VERSION).tar.gz
PERL_SYS_MEMINFO_SITE = $(BR2_CPAN_MIRROR)/authors/id/S/SC/SCRESTO
PERL_SYS_MEMINFO_LICENSE = Artistic or GPL-1.0+
PERL_SYS_MEMINFO_LICENSE_FILES = LICENSE
PERL_SYS_MEMINFO_DISTNAME = Sys-MemInfo

$(eval $(perl-package))
