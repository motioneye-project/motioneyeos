################################################################################
#
# perl-http-entity-parser
#
################################################################################

PERL_HTTP_ENTITY_PARSER_VERSION = 0.21
PERL_HTTP_ENTITY_PARSER_SOURCE = HTTP-Entity-Parser-$(PERL_HTTP_ENTITY_PARSER_VERSION).tar.gz
PERL_HTTP_ENTITY_PARSER_SITE = $(BR2_CPAN_MIRROR)/authors/id/K/KA/KAZEBURO
PERL_HTTP_ENTITY_PARSER_DEPENDENCIES = host-perl-module-build-tiny
PERL_HTTP_ENTITY_PARSER_LICENSE = Artistic or GPL-1.0+
PERL_HTTP_ENTITY_PARSER_LICENSE_FILES = LICENSE
PERL_HTTP_ENTITY_PARSER_DISTNAME = HTTP-Entity-Parser

$(eval $(perl-package))
