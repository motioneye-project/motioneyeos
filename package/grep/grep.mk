#############################################################
#
# grep
#
#############################################################

GREP_VERSION = 2.7
GREP_SITE = $(BR2_GNU_MIRROR)/grep
GREP_CONF_OPT = --disable-perl-regexp --without-included-regex
GREP_DEPENDENCIES = $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext libintl)

# link with iconv if enabled
ifeq ($(BR2_PACKAGE_LIBICONV),y)
GREP_CONF_ENV += LIBS=-liconv
GREP_DEPENDENCIES += libiconv
endif

$(eval $(call AUTOTARGETS,package,grep))
