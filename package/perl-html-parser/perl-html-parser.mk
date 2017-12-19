################################################################################
#
# perl-html-parser
#
################################################################################

PERL_HTML_PARSER_VERSION = 3.72
PERL_HTML_PARSER_SOURCE = HTML-Parser-$(PERL_HTML_PARSER_VERSION).tar.gz
PERL_HTML_PARSER_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GA/GAAS
PERL_HTML_PARSER_DEPENDENCIES = perl-html-tagset
PERL_HTML_PARSER_LICENSE = Artistic or GPL-1.0+
PERL_HTML_PARSER_LICENSE_FILES = README

$(eval $(perl-package))
