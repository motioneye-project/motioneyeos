#############################################################
#
# MatchBox Applet Startup monitor
#
#############################################################

MATCHBOX_STARTUP_MONITOR_VERSION = 0.1
MATCHBOX_STARTUP_MONITOR_SOURCE = mb-applet-startup-monitor-$(MATCHBOX_STARTUP_MONITOR_VERSION).tar.bz2
MATCHBOX_STARTUP_MONITOR_SITE = http://matchbox-project.org/sources/mb-applet-startup-monitor/$(MATCHBOX_STARTUP_MONITOR_VERSION)
MATCHBOX_STARTUP_MONITOR_DEPENDENCIES = matchbox-lib startup-notification
MATCHBOX_STARTUP_MONITOR_CONF_OPT =

#############################################################

$(eval $(autotools-package))
