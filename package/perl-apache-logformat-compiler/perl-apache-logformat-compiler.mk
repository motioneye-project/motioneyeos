################################################################################
#
# perl-apache-logformat-compiler
#
################################################################################

PERL_APACHE_LOGFORMAT_COMPILER_VERSION = 0.35
PERL_APACHE_LOGFORMAT_COMPILER_SOURCE = Apache-LogFormat-Compiler-$(PERL_APACHE_LOGFORMAT_COMPILER_VERSION).tar.gz
PERL_APACHE_LOGFORMAT_COMPILER_SITE = $(BR2_CPAN_MIRROR)/authors/id/K/KA/KAZEBURO
PERL_APACHE_LOGFORMAT_COMPILER_DEPENDENCIES = host-perl-module-build-tiny perl-posix-strftime-compiler
PERL_APACHE_LOGFORMAT_COMPILER_LICENSE = Artistic or GPL-1.0+
PERL_APACHE_LOGFORMAT_COMPILER_LICENSE_FILES = LICENSE

$(eval $(perl-package))
