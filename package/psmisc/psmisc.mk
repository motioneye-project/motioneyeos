#############################################################
#
# psmisc
#
#############################################################

PSMISC_VERSION = 22.13
PSMISC_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/psmisc
PSMISC_DEPENDENCIES = ncurses $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext libintl)

# build after busybox, we prefer fat versions while we're at it
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
PSMISC_DEPENDENCIES += busybox
endif

$(eval $(call AUTOTARGETS,package,psmisc))
