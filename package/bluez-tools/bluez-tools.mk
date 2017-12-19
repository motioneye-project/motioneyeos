################################################################################
#
# bluez-tools
#
################################################################################

ifeq ($(BR2_PACKAGE_BLUEZ_UTILS),y)
# this is the last version compatible with BlueZ 4 API
BLUEZ_TOOLS_VERSION = 171181b6ef6c94aefc828dc7fd8de136b9f97532
else
BLUEZ_TOOLS_VERSION = 97efd293491ad7ec96a655665339908f2478b3d1
endif
BLUEZ_TOOLS_SITE = $(call github,khvzak,bluez-tools,$(BLUEZ_TOOLS_VERSION))

# sources fetched from github, no configure script)
BLUEZ_TOOLS_AUTORECONF = YES
BLUEZ_TOOLS_DEPENDENCIES = host-pkgconf dbus dbus-glib
BLUEZ_TOOLS_LICENSE = GPL-2.0+
BLUEZ_TOOLS_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_BLUEZ_UTILS),y)
BLUEZ_TOOLS_DEPENDENCIES += bluez_utils
# readline is an optional dependency when used with bluez_utils
# obex support depends on readline so enable it optionally
ifeq ($(BR2_PACKAGE_READLINE),y)
BLUEZ_TOOLS_CONF_OPTS += --enable-obex
BLUEZ_TOOLS_DEPENDENCIES += readline
else
BLUEZ_TOOLS_CONF_OPTS += --disable-obex
endif
else
# readline is a hard dependency when used with bluez5_utils
BLUEZ_TOOLS_DEPENDENCIES += bluez5_utils readline
endif

$(eval $(autotools-package))
