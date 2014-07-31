################################################################################
#
# udisks
#
################################################################################

UDISKS_VERSION = 1.0.4
UDISKS_SITE    = http://hal.freedesktop.org/releases
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

UDISKS_CONF_OPT = --disable-remote-access --disable-man-pages

ifeq ($(BR2_PACKAGE_UDISKS_LVM2),y)
UDISKS_CONF_OPT += --enable-lvm2
endif

$(eval $(autotools-package))
