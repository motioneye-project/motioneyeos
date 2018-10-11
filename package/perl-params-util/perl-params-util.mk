################################################################################
#
# perl-params-util
#
################################################################################

PERL_PARAMS_UTIL_VERSION = 1.07
PERL_PARAMS_UTIL_SOURCE = Params-Util-$(PERL_PARAMS_UTIL_VERSION).tar.gz
PERL_PARAMS_UTIL_SITE = $(BR2_CPAN_MIRROR)/authors/id/A/AD/ADAMK
PERL_PARAMS_UTIL_LICENSE = Artistic or GPL-1.0+
PERL_PARAMS_UTIL_LICENSE_FILES = LICENSE
PERL_PARAMS_UTIL_DISTNAME = Params-Util

$(eval $(perl-package))
