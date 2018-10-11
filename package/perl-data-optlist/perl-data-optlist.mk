################################################################################
#
# perl-data-optlist
#
################################################################################

PERL_DATA_OPTLIST_VERSION = 0.110
PERL_DATA_OPTLIST_SOURCE = Data-OptList-$(PERL_DATA_OPTLIST_VERSION).tar.gz
PERL_DATA_OPTLIST_SITE = $(BR2_CPAN_MIRROR)/authors/id/R/RJ/RJBS
PERL_DATA_OPTLIST_LICENSE = Artistic or GPL-1.0+
PERL_DATA_OPTLIST_LICENSE_FILES = LICENSE
PERL_DATA_OPTLIST_DISTNAME = Data-OptList

$(eval $(perl-package))
