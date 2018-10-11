################################################################################
#
# perl-type-tiny
#
################################################################################

PERL_TYPE_TINY_VERSION = 1.004002
PERL_TYPE_TINY_SOURCE = Type-Tiny-$(PERL_TYPE_TINY_VERSION).tar.gz
PERL_TYPE_TINY_SITE = $(BR2_CPAN_MIRROR)/authors/id/T/TO/TOBYINK
PERL_TYPE_TINY_LICENSE = Artistic or GPL-1.0+
PERL_TYPE_TINY_LICENSE_FILES = COPYRIGHT LICENSE
PERL_TYPE_TINY_DISTNAME = Type-Tiny

$(eval $(perl-package))
