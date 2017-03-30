################################################################################
#
# udisks
#
################################################################################

UDISKS_VERSION = 1.0.5
UDISKS_SITE = http://hal.freedesktop.org/releases
UDISKS_LICENSE = GPL-2.0+
UDISKS_LICENSE_FILES = COPYING
# For 0002-Fix-systemd-service-file.patch
UDISKS_AUTORECONF = YES

UDISKS_DEPENDENCIES =	\
	sg3_utils	\
	host-pkgconf	\
	udev		\
	dbus		\
	dbus-glib	\
	polkit		\
	parted		\
	lvm2		\
	libatasmart	\
	libgudev

UDISKS_CONF_OPTS = --disable-remote-access --disable-man-pages

ifeq ($(BR2_PACKAGE_UDISKS_LVM2),y)
UDISKS_CONF_OPTS += --enable-lvm2
endif

$(eval $(autotools-package))
