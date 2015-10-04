################################################################################
#
# perl-xml-sax
#
################################################################################

PERL_XML_SAX_VERSION = 0.99
PERL_XML_SAX_SOURCE = XML-SAX-$(PERL_XML_SAX_VERSION).tar.gz
PERL_XML_SAX_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GR/GRANTM
PERL_XML_SAX_DEPENDENCIES = perl perl-xml-namespacesupport perl-xml-sax-base
PERL_XML_SAX_LICENSE = Artistic or GPLv1+
PERL_XML_SAX_LICENSE_FILES = LICENSE

$(eval $(perl-package))
