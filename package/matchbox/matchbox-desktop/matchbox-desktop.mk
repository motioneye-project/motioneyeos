#############################################################
#
# MatchBox Desktop
#
#############################################################

MATCHBOX_DESKTOP_VERSION = 0.9.1
MATCHBOX_DESKTOP_SOURCE = matchbox-desktop-$(MATCHBOX_DESKTOP_VERSION).tar.bz2
MATCHBOX_DESKTOP_SITE = http://matchbox-project.org/sources/matchbox-desktop/$(MATCHBOX_DESKTOP_VERSION)
MATCHBOX_DESKTOP_DEPENDENCIES = matchbox-lib
MATCHBOX_DESKTOP_CONF_OPT = --enable-expat

#############################################################

ifeq ($(BR2_PACKAGE_STARTUP_NOTIFICATION),y)
  MATCHBOX_DESKTOP_CONF_OPT+=--enable-startup-notification
  MATCHBOX_DESKTOP_DEPENDENCIES+=startup-notification
else
  MATCHBOX_DESKTOP_CONF_OPT+=--disable-startup-notification
endif

#############################################################

$(eval $(autotools-package))
