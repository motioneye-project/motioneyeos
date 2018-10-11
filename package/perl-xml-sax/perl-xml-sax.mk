################################################################################
#
# perl-xml-sax
#
################################################################################

PERL_XML_SAX_VERSION = 1.00
PERL_XML_SAX_SOURCE = XML-SAX-$(PERL_XML_SAX_VERSION).tar.gz
PERL_XML_SAX_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GR/GRANTM
PERL_XML_SAX_LICENSE = Artistic or GPL-1.0+
PERL_XML_SAX_LICENSE_FILES = LICENSE
PERL_XML_SAX_DISTNAME = XML-SAX

$(eval $(perl-package))
