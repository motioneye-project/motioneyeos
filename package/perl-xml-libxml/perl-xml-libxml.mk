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

PERL_XML_LIBXML_CONF_OPT = \
	LIBS="-L $(STAGING_DIR)/usr/lib" \
	INC="-I $(STAGING_DIR)/usr/include/libxml2" \
	NO_THREADS

$(eval $(perl-package))
