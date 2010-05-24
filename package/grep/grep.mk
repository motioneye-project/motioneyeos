#############################################################
#
# grep
#
#############################################################
GREP_VERSION:=2.5.3
GREP_SOURCE:=grep-$(GREP_VERSION).tar.bz2
GREP_SITE:=$(BR2_GNU_MIRROR)/grep
GREP_CONF_OPT = --disable-perl-regexp --without-included-regex

GREP_DEPENDENCIES = $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext libintl)

$(eval $(call AUTOTARGETS,package,grep))
