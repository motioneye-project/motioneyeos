################################################################################
#
# perl-apache-logformat-compiler
#
################################################################################

PERL_APACHE_LOGFORMAT_COMPILER_VERSION = 0.36
PERL_APACHE_LOGFORMAT_COMPILER_SOURCE = Apache-LogFormat-Compiler-$(PERL_APACHE_LOGFORMAT_COMPILER_VERSION).tar.gz
PERL_APACHE_LOGFORMAT_COMPILER_SITE = $(BR2_CPAN_MIRROR)/authors/id/K/KA/KAZEBURO
PERL_APACHE_LOGFORMAT_COMPILER_DEPENDENCIES = host-perl-module-build-tiny
PERL_APACHE_LOGFORMAT_COMPILER_LICENSE = Artistic or GPL-1.0+
PERL_APACHE_LOGFORMAT_COMPILER_LICENSE_FILES = LICENSE
PERL_APACHE_LOGFORMAT_COMPILER_DISTNAME = Apache-LogFormat-Compiler

$(eval $(perl-package))
