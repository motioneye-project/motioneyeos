#############################################################
#
# MatchBox Panel
#
#############################################################

MATCHBOX_PANEL_VERSION = 0.9.3
MATCHBOX_PANEL_SOURCE = matchbox-panel-$(MATCHBOX_PANEL_VERSION).tar.bz2
MATCHBOX_PANEL_SITE = http://matchbox-project.org/sources/matchbox-panel/$(MATCHBOX_PANEL_VERSION)
MATCHBOX_PANEL_DEPENDENCIES = matchbox-lib
MATCHBOX_PANEL_CONF_OPT = --enable-expat

#############################################################

ifeq ($(BR2_PACKAGE_STARTUP_NOTIFICATION),y)
  MATCHBOX_PANEL_CONF_OPT+=--enable-startup-notification
  MATCHBOX_PANEL_DEPENDENCIES+=startup-notification matchbox-startup-monitor
else
  MATCHBOX_PANEL_CONF_OPT+=--disable-startup-notification
endif

#############################################################

$(eval $(autotools-package))
