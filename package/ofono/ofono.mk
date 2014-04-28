################################################################################
#
# ofono
#
################################################################################

OFONO_VERSION = 1.14
OFONO_SOURCE = ofono-$(OFONO_VERSION).tar.xz
OFONO_SITE = $(BR2_KERNEL_MIRROR)/linux/network/ofono
OFONO_LICENSE = GPLv2
OFONO_LICENSE_FILES = COPYING
OFONO_DEPENDENCIES = \
	host-pkgconf \
	dbus \
	libglib2 \
	libcap-ng \
	mobile-broadband-provider-info

OFONO_CONF_OPT = --disable-test

# N.B. Qualcomm QMI modem support requires O_CLOEXEC; so
# make sure that it is defined.
OFONO_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE"

define OFONO_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/ofono/S46ofono $(TARGET_DIR)/etc/init.d/S46ofono
endef

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
	OFONO_CONF_OPT += --enable-udev
	OFONO_DEPENDENCIES += udev
else
	OFONO_CONF_OPT += --disable-udev
endif

ifeq ($(BR2_PACKAGE_BLUEZ_UTILS),y)
	OFONO_CONF_OPT += --enable-bluetooth
	OFONO_DEPENDENCIES += bluez_utils
else
	OFONO_CONF_OPT += --disable-bluetooth
endif

$(eval $(autotools-package))
