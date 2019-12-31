################################################################################
#
# thermald
#
################################################################################

THERMALD_VERSION = 1.9.1
THERMALD_SITE = $(call github,intel,thermal_daemon,v$(THERMALD_VERSION))
# fetched from Github, with no configure script
THERMALD_AUTORECONF = YES
THERMALD_DEPENDENCIES = dbus dbus-glib libxml2
# tools are GPL-3.0+ but are not added to the target
THERMALD_LICENSE = GPL-2.0+
THERMALD_LICENSE_FILES = COPYING

ifeq ($(BR2_INIT_SYSTEMD),y)
THERMALD_DEPENDENCIES += systemd
THERMALD_CONF_OPTS += --with-systemdsystemunitdir=/usr/lib/systemd/system
endif

$(eval $(autotools-package))
