################################################################################
#
# matchbox-panel
#
################################################################################

MATCHBOX_PANEL_VERSION_MAJOR = 0.9
MATCHBOX_PANEL_VERSION = $(MATCHBOX_PANEL_VERSION_MAJOR).3
MATCHBOX_PANEL_SOURCE = matchbox-panel-$(MATCHBOX_PANEL_VERSION).tar.bz2
MATCHBOX_PANEL_SITE = http://downloads.yoctoproject.org/releases/matchbox/matchbox-panel/$(MATCHBOX_PANEL_VERSION_MAJOR)
MATCHBOX_PANEL_LICENSE = GPL-2.0+
MATCHBOX_PANEL_LICENSE_FILES = COPYING
MATCHBOX_PANEL_DEPENDENCIES = matchbox-lib $(TARGET_NLS_DEPENDENCIES)
MATCHBOX_PANEL_CONF_ENV = LIBS=$(TARGET_NLS_LIBS)
MATCHBOX_PANEL_CONF_OPTS = --enable-expat --enable-dnotify

ifeq ($(BR2_PACKAGE_MATCHBOX_STARTUP_MONITOR),y)
MATCHBOX_PANEL_CONF_OPTS += --enable-startup-notification
MATCHBOX_PANEL_DEPENDENCIES += matchbox-startup-monitor
else
MATCHBOX_PANEL_CONF_OPTS += --disable-startup-notification
endif

# Using ACPI is only possible on x86 (32- or 64-bit) or AArch64
ifeq ($(BR2_aarch64)$(BR2_i386)$(BR2_x86_64),y)
MATCHBOX_PANEL_CONF_OPTS += --enable-acpi-linux
else
MATCHBOX_PANEL_CONF_OPTS += --disable-acpi-linux
endif

ifeq ($(BR2_PACKAGE_WIRELESS_TOOLS_LIB),y)
MATCHBOX_PANEL_DEPENDENCIES += wireless_tools
endif

$(eval $(autotools-package))
