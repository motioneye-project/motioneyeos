################################################################################
#
# perl-math-bigint
#
################################################################################

PERL_MATH_BIGINT_VERSION = 1.999818
PERL_MATH_BIGINT_SOURCE = Math-BigInt-$(PERL_MATH_BIGINT_VERSION).tar.gz
PERL_MATH_BIGINT_SITE = $(BR2_CPAN_MIRROR)/authors/id/P/PJ/PJACKLAM
PERL_MATH_BIGINT_LICENSE = Artistic or GPL-1.0+
PERL_MATH_BIGINT_LICENSE_FILES = LICENSE
PERL_MATH_BIGINT_DISTNAME = Math-BigInt

$(eval $(perl-package))
