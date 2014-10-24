################################################################################
#
# matchbox-panel
#
################################################################################

MATCHBOX_PANEL_VERSION_MAJOR = 0.9
MATCHBOX_PANEL_VERSION = $(MATCHBOX_PANEL_VERSION_MAJOR).3
MATCHBOX_PANEL_SOURCE = matchbox-panel-$(MATCHBOX_PANEL_VERSION).tar.bz2
MATCHBOX_PANEL_SITE = http://downloads.yoctoproject.org/releases/matchbox/matchbox-panel/$(MATCHBOX_PANEL_VERSION_MAJOR)
MATCHBOX_PANEL_LICENSE = GPLv2+
MATCHBOX_PANEL_LICENSE_FILES = COPYING
MATCHBOX_PANEL_DEPENDENCIES = matchbox-lib
MATCHBOX_PANEL_CONF_OPTS = --enable-expat

################################################################################

ifeq ($(BR2_PACKAGE_STARTUP_NOTIFICATION),y)
MATCHBOX_PANEL_CONF_OPTS += --enable-startup-notification
MATCHBOX_PANEL_DEPENDENCIES += startup-notification matchbox-startup-monitor
else
MATCHBOX_PANEL_CONF_OPTS += --disable-startup-notification
endif

################################################################################

$(eval $(autotools-package))
