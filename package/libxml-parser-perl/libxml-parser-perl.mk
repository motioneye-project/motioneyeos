#############################################################
#
# libxml-parser-perl
#
#############################################################
LIBXML_PARSER_PERL_VERSION:=2.36
LIBXML_PARSER_PERL_SOURCE:=XML-Parser-$(LIBXML_PARSER_PERL_VERSION).tar.gz
LIBXML_PARSER_PERL_SITE:=http://www.cpan.org/modules/by-module/XML/

LIBXML_PARSER_PERL_DEPENDENCIES = expat

ifeq ($(BR2_PACKAGE_MICROPERL),y)
# microperl builds host-microperl, so ensure we build after that to build
# against host-microperl instead of the system perl
LIBXML_PARSER_PERL_DEPENDENCIES += microperl
endif

define HOST_LIBXML_PARSER_PERL_CONFIGURE_CMDS
 (cd $(@D) ; \
   $(HOST_CONFIGURE_OPTS) perl Makefile.PL \
        PREFIX=$(HOST_DIR)/usr \
        EXPATLIBPATH=$(HOST_DIR)/usr/lib \
        EXPATINCPATH=$(HOST_DIR)/usr/include \
        INSTALLDIRS=site \
        INSTALLSITELIB=$(HOST_DIR)/usr/lib/perl \
        INSTALLSITEARCH=$(HOST_DIR)/usr/lib/perl \
        USE_MM_LD_RUN_PATH=1 \
 )
endef

define HOST_LIBXML_PARSER_PERL_BUILD_CMDS
 $(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_LIBXML_PARSER_PERL_INSTALL_CMDS
 $(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))

