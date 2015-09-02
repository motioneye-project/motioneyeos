################################################################################
#
# udisks
#
################################################################################

UDISKS_VERSION = 1.0.5
UDISKS_SITE = http://hal.freedesktop.org/releases
UDISKS_LICENSE = GPLv2+
UDISKS_LICENSE_FILES = COPYING

UDISKS_DEPENDENCIES = 	\
	sg3_utils	\
	host-pkgconf	\
	udev		\
	dbus		\
	dbus-glib	\
	polkit		\
	parted		\
	lvm2		\
	libatasmart

UDISKS_CONF_OPTS = --disable-remote-access --disable-man-pages

# When eudev is used as the udev provider, libgudev is automatically
# provided as it is part of eudev. However, when systemd is used as the
# udev provider, libgudev is not provided, and needs to be built
# separately. This is why we select the libgudev package only if systemd
# is used.
ifeq ($(BR2_PACKAGE_SYSTEMD),y)
UDISKS_DEPENDENCIES += libgudev
endif

ifeq ($(BR2_PACKAGE_UDISKS_LVM2),y)
UDISKS_CONF_OPTS += --enable-lvm2
endif

$(eval $(autotools-package))
