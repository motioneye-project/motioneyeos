################################################################################
#
# perl-sys-cpu
#
################################################################################

PERL_SYS_CPU_VERSION = 0.52
PERL_SYS_CPU_SOURCE = Sys-CPU-$(PERL_SYS_CPU_VERSION).tar.gz
PERL_SYS_CPU_SITE = $(BR2_CPAN_MIRROR)/authors/id/M/MK/MKODERER
PERL_SYS_CPU_LICENSE = Artistic or GPL-1.0+
PERL_SYS_CPU_LICENSE_FILES = README

$(eval $(perl-package))
