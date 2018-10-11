################################################################################
#
# perl-try-tiny
#
################################################################################

PERL_TRY_TINY_VERSION = 0.30
PERL_TRY_TINY_SOURCE = Try-Tiny-$(PERL_TRY_TINY_VERSION).tar.gz
PERL_TRY_TINY_SITE = $(BR2_CPAN_MIRROR)/authors/id/E/ET/ETHER
PERL_TRY_TINY_LICENSE = MIT
PERL_TRY_TINY_LICENSE_FILES = README
PERL_TRY_TINY_DISTNAME = Try-Tiny

$(eval $(perl-package))
