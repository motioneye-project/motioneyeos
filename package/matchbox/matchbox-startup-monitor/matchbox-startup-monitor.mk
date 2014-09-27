################################################################################
#
# matchbox-startup-monitor
#
################################################################################

MATCHBOX_STARTUP_MONITOR_VERSION = 0.1
MATCHBOX_STARTUP_MONITOR_SOURCE = mb-applet-startup-monitor-$(MATCHBOX_STARTUP_MONITOR_VERSION).tar.bz2
MATCHBOX_STARTUP_MONITOR_SITE = http://downloads.yoctoproject.org/releases/matchbox/mb-applet-startup-monitor/$(MATCHBOX_STARTUP_MONITOR_VERSION)
MATCHBOX_STARTUP_MONITOR_LICENSE = GPLv2+
MATCHBOX_STARTUP_MONITOR_LICENSE_FILES = COPYING
MATCHBOX_STARTUP_MONITOR_DEPENDENCIES = matchbox-lib startup-notification
MATCHBOX_STARTUP_MONITOR_CONF_OPTS =

################################################################################

$(eval $(autotools-package))
