################################################################################
#
# drbd-utils
#
################################################################################

DRBD_UTILS_VERSION = 8.9.4
DRBD_UTILS_SITE = http://oss.linbit.com/drbd
DRBD_UTILS_LICENSE = GPLv2+
DRBD_UTILS_LICENSE_FILES = COPYING
DRBD_UTILS_DEPENDENCIES = host-flex

DRBD_UTILS_CONF_OPTS = --with-distro=generic --without-manual

ifeq ($(BR2_INIT_SYSTEMD),y)
DRBD_UTILS_CONF_OPTS += --with-initscripttype=systemd
DRBD_UTILS_DEPENDENCIES += systemd
else
DRBD_UTILS_CONF_OPTS += --with-initscripttype=sysv
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
DRBD_UTILS_CONF_OPTS += --with-udev=yes
DRBD_UTILS_DEPENDENCIES += udev
else
DRBD_UTILS_CONF_OPTS += --with-udev=no
endif

$(eval $(autotools-package))
