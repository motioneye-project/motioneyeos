################################################################################
#
# perl-class-load
#
################################################################################

PERL_CLASS_LOAD_VERSION = 0.25
PERL_CLASS_LOAD_SOURCE = Class-Load-$(PERL_CLASS_LOAD_VERSION).tar.gz
PERL_CLASS_LOAD_SITE = $(BR2_CPAN_MIRROR)/authors/id/E/ET/ETHER
PERL_CLASS_LOAD_DEPENDENCIES = \
	perl-data-optlist \
	perl-module-implementation \
	perl-module-runtime \
	perl-package-stash \
	perl-try-tiny
PERL_CLASS_LOAD_LICENSE = Artistic or GPL-1.0+
PERL_CLASS_LOAD_LICENSE_FILES = LICENSE

$(eval $(perl-package))
