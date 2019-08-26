################################################################################
#
# pipewire
#
################################################################################

PIPEWIRE_VERSION = 0.2.7
PIPEWIRE_SITE = $(call github,PipeWire,pipewire,$(PIPEWIRE_VERSION))
PIPEWIRE_LICENSE = LGPL-2.1+
PIPEWIRE_LICENSE_FILES = LICENSE LGPL
PIPEWIRE_INSTALL_STAGING = YES
PIPEWIRE_DEPENDENCIES = host-pkgconf dbus
PIPEWIRE_CONF_OPTS = -Dgstreamer=disabled

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
PIPEWIRE_CONF_OPTS += -Dsystemd=true
PIPEWIRE_DEPENDENCIES += systemd
else
PIPEWIRE_CONF_OPTS += -Dsystemd=false
endif

$(eval $(meson-package))
