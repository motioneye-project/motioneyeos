#############################################################
#
# ofono
#
#############################################################
OFONO_VERSION = 1.6
OFONO_SITE = $(BR2_KERNEL_MIRROR)/linux/network/ofono
OFONO_DEPENDENCIES = \
	host-pkg-config \
	dbus \
	libglib2 \
	libcap-ng \
	mobile-broadband-provider-info

OFONO_CONF_OPT = --disable-test

ifeq ($(BR2_PACKAGE_UDEV),y)
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
