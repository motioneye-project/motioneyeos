#############################################################
#
# psmisc
#
#############################################################
PSMISC_VERSION:=22.8
PSMISC_SOURCE:=psmisc-$(PSMISC_VERSION).tar.gz
PSMISC_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/psmisc
PSMISC_AUTORECONF:=NO
PSMISC_DEPENDENCIES:=ncurses

ifeq ($(BR2_ENABLE_LOCALE),y)
# psmisc gets confused and forgets to link with libintl
PSMISC_MAKE_OPT:=LIBS=-lintl
PSMISC_DEPENDENCIES+= gettext libintl
endif

$(eval $(call AUTOTARGETS,package,psmisc))
