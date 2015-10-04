################################################################################
#
# perl-try-tiny
#
################################################################################

PERL_TRY_TINY_VERSION = 0.22
PERL_TRY_TINY_SOURCE = Try-Tiny-$(PERL_TRY_TINY_VERSION).tar.gz
PERL_TRY_TINY_SITE = $(BR2_CPAN_MIRROR)/authors/id/D/DO/DOY
PERL_TRY_TINY_DEPENDENCIES = perl
PERL_TRY_TINY_LICENSE = MIT
PERL_TRY_TINY_LICENSE_FILES = LICENSE

$(eval $(perl-package))
