################################################################################
#
# bluez-tools
#
################################################################################

BLUEZ_TOOLS_VERSION = 97efd293491ad7ec96a655665339908f2478b3d1
BLUEZ_TOOLS_SITE = $(call github,khvzak,bluez-tools,$(BLUEZ_TOOLS_VERSION))

# sources fetched from github, no configure script)
BLUEZ_TOOLS_AUTORECONF = YES
BLUEZ_TOOLS_DEPENDENCIES = host-pkgconf dbus dbus-glib bluez5_utils readline
BLUEZ_TOOLS_LICENSE = GPL-2.0+
BLUEZ_TOOLS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
