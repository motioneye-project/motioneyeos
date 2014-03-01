################################################################################
#
# perl-xml-parser
#
################################################################################

PERL_XML_PARSER_VERSION = 2.41
PERL_XML_PARSER_SOURCE = XML-Parser-$(PERL_XML_PARSER_VERSION).tar.gz
PERL_XML_PARSER_SITE = $(BR2_CPAN_MIRROR)/authors/id/T/TO/TODDR/
PERL_XML_PARSER_DEPENDENCIES = expat
PERL_XML_PARSER_LICENSE = Artistic or GPLv1+

HOST_PERL_XML_PARSER_CONF_OPT = \
	EXPATLIBPATH=$(HOST_DIR)/usr/lib \
	EXPATINCPATH=$(HOST_DIR)/usr/include

$(eval $(host-perl-package))
