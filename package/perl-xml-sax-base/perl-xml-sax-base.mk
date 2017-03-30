################################################################################
#
# perl-xml-sax-base
#
################################################################################

PERL_XML_SAX_BASE_VERSION = 1.08
PERL_XML_SAX_BASE_SOURCE = XML-SAX-Base-$(PERL_XML_SAX_BASE_VERSION).tar.gz
PERL_XML_SAX_BASE_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GR/GRANTM
PERL_XML_SAX_BASE_LICENSE = Artistic or GPL-1.0+
PERL_XML_SAX_BASE_LICENSE_FILES = README

$(eval $(perl-package))
