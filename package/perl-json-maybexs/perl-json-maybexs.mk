################################################################################
#
# perl-json-maybexs
#
################################################################################

PERL_JSON_MAYBEXS_VERSION = 1.004000
PERL_JSON_MAYBEXS_SOURCE = JSON-MaybeXS-$(PERL_JSON_MAYBEXS_VERSION).tar.gz
PERL_JSON_MAYBEXS_SITE = $(BR2_CPAN_MIRROR)/authors/id/H/HA/HAARG
PERL_JSON_MAYBEXS_LICENSE = Artistic or GPL-1.0+
PERL_JSON_MAYBEXS_LICENSE_FILES = README
PERL_JSON_MAYBEXS_DISTNAME = JSON-MaybeXS

$(eval $(perl-package))
