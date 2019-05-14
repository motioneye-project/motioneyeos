################################################################################
#
# perl-module-runtime
#
################################################################################

PERL_MODULE_RUNTIME_VERSION = 0.016
PERL_MODULE_RUNTIME_SOURCE = Module-Runtime-$(PERL_MODULE_RUNTIME_VERSION).tar.gz
PERL_MODULE_RUNTIME_SITE = $(BR2_CPAN_MIRROR)/authors/id/Z/ZE/ZEFRAM
PERL_MODULE_RUNTIME_DEPENDENCIES = host-perl-module-build
PERL_MODULE_RUNTIME_LICENSE = Artistic or GPL-1.0+
PERL_MODULE_RUNTIME_LICENSE_FILES = README
PERL_MODULE_RUNTIME_DISTNAME = Module-Runtime

$(eval $(perl-package))
