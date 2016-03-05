################################################################################
#
# perl-gdgraph
#
################################################################################

PERL_GDGRAPH_VERSION = 1.49
PERL_GDGRAPH_SOURCE = GDGraph-$(PERL_GDGRAPH_VERSION).tar.gz
PERL_GDGRAPH_SITE = $(BR2_CPAN_MIRROR)/authors/id/R/RU/RUZ
PERL_GDGRAPH_DEPENDENCIES = perl-gd perl-gdtextutil
PERL_GDGRAPH_LICENSE = Artistic or GPLv1+
PERL_GDGRAPH_LICENSE_FILES = Dustismo.LICENSE

$(eval $(perl-package))
