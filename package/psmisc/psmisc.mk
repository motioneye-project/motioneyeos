#############################################################
#
# psmisc
#
#############################################################
PSMISC_VERSION:=22.8
PSMISC_SOURCE:=psmisc-$(PSMISC_VERSION).tar.gz
PSMISC_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/psmisc
PSMISC_AUTORECONF:=NO
PSMISC_DEPENDENCIES:=ncurses $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext libintl)

$(eval $(call AUTOTARGETS,package,psmisc))
