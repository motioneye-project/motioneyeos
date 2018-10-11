################################################################################
#
# perl-gdgraph
#
################################################################################

PERL_GDGRAPH_VERSION = 1.54
PERL_GDGRAPH_SOURCE = GDGraph-$(PERL_GDGRAPH_VERSION).tar.gz
PERL_GDGRAPH_SITE = $(BR2_CPAN_MIRROR)/authors/id/R/RU/RUZ
PERL_GDGRAPH_LICENSE = Artistic or GPL-1.0+
PERL_GDGRAPH_LICENSE_FILES = Dustismo.LICENSE
PERL_GDGRAPH_DISTNAME = GDGraph

$(eval $(perl-package))
