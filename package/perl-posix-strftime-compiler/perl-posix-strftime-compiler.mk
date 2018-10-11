################################################################################
#
# perl-posix-strftime-compiler
#
################################################################################

PERL_POSIX_STRFTIME_COMPILER_VERSION = 0.42
PERL_POSIX_STRFTIME_COMPILER_SOURCE = POSIX-strftime-Compiler-$(PERL_POSIX_STRFTIME_COMPILER_VERSION).tar.gz
PERL_POSIX_STRFTIME_COMPILER_SITE = $(BR2_CPAN_MIRROR)/authors/id/K/KA/KAZEBURO
PERL_POSIX_STRFTIME_COMPILER_DEPENDENCIES = host-perl-module-build
PERL_POSIX_STRFTIME_COMPILER_LICENSE = Artistic or GPL-1.0+
PERL_POSIX_STRFTIME_COMPILER_LICENSE_FILES = LICENSE
PERL_POSIX_STRFTIME_COMPILER_DISTNAME = POSIX-strftime-Compiler

$(eval $(perl-package))
