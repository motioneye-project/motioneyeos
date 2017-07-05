################################################################################
#
# libxml-parser-perl
#
################################################################################

LIBXML_PARSER_PERL_VERSION = 2.44
LIBXML_PARSER_PERL_SOURCE = XML-Parser-$(LIBXML_PARSER_PERL_VERSION).tar.gz
LIBXML_PARSER_PERL_SITE = $(BR2_CPAN_MIRROR)/authors/id/T/TO/TODDR
HOST_LIBXML_PARSER_PERL_DEPENDENCIES = host-expat
LIBXML_PARSER_PERL_LICENSE = Artistic or GPL-1.0+
LIBXML_PARSER_PERL_RUN_PERL = `which perl`

define HOST_LIBXML_PARSER_PERL_CONFIGURE_CMDS
	(cd $(@D) ; \
		$(HOST_CONFIGURE_OPTS) $(LIBXML_PARSER_PERL_RUN_PERL) Makefile.PL \
			PREFIX=$(HOST_DIR) \
			EXPATLIBPATH=$(HOST_DIR)/lib \
			EXPATINCPATH=$(HOST_DIR)/include \
			INSTALLDIRS=site \
			INSTALLSITELIB=$(HOST_DIR)/lib/perl \
			INSTALLSITEARCH=$(HOST_DIR)/lib/perl \
	)
endef

define HOST_LIBXML_PARSER_PERL_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_LIBXML_PARSER_PERL_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
endef

$(eval $(host-generic-package))
