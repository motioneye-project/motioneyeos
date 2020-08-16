################################################################################
#
# perl-math-prime-util
#
################################################################################

PERL_MATH_PRIME_UTIL_VERSION = 0.73
PERL_MATH_PRIME_UTIL_SOURCE = Math-Prime-Util-$(PERL_MATH_PRIME_UTIL_VERSION).tar.gz
PERL_MATH_PRIME_UTIL_SITE = $(BR2_CPAN_MIRROR)/authors/id/D/DA/DANAJ
PERL_MATH_PRIME_UTIL_LICENSE = Artistic or GPL-1.0+
PERL_MATH_PRIME_UTIL_LICENSE_FILES = LICENSE
PERL_MATH_PRIME_UTIL_DISTNAME = Math-Prime-Util

$(eval $(perl-package))
