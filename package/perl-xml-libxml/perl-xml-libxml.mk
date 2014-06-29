################################################################################
#
# perl-xml-libxml
#
################################################################################

PERL_XML_LIBXML_VERSION = 2.0116
PERL_XML_LIBXML_SOURCE = XML-LibXML-$(PERL_XML_LIBXML_VERSION).tar.gz
PERL_XML_LIBXML_SITE = $(BR2_CPAN_MIRROR)/authors/id/S/SH/SHLOMIF/
PERL_XML_LIBXML_DEPENDENCIES = perl zlib libxml2 perl-xml-sax perl-xml-namespacesupport
PERL_XML_LIBXML_LICENSE = Artistic or GPLv1+
PERL_XML_LIBXML_LICENSE_FILES = LICENSE

$(eval $(perl-package))
