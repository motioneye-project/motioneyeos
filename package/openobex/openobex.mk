################################################################################
#
# openobex
#
################################################################################

OPENOBEX_VERSION = 1.5
OPENOBEX_SITE = http://ftp.osuosl.org/pub/linux/bluetooth
# Libraries seems to be released under LGPLv2.1+,
# while other material is under GPLv2+.
OPENOBEX_LICENSE = GPLv2+/LGPLv2.1+
OPENOBEX_LICENSE_FILES = COPYING COPYING.LIB

OPENOBEX_DEPENDENCIES = host-pkgconf
OPENOBEX_AUTORECONF = YES
OPENOBEX_INSTALL_STAGING = YES

OPENOBEX_CONF_OPTS += \
	$(if $(BR2_PACKAGE_OPENOBEX_APPS),--enable-apps) \
	$(if $(BR2_PACKAGE_OPENOBEX_SYSLOG),--enable-syslog) \
	$(if $(BR2_PACKAGE_OPENOBEX_DUMP),--enable-dump)

ifeq ($(BR2_PACKAGE_OPENOBEX_BLUEZ),y)
OPENOBEX_DEPENDENCIES += bluez_utils
OPENOBEX_CONF_OPTS += --with-bluez=$(STAGING_DIR)
else
OPENOBEX_CONF_OPTS += --disable-bluetooth
endif

ifeq ($(BR2_PACKAGE_OPENOBEX_LIBUSB),y)
OPENOBEX_DEPENDENCIES += libusb
OPENOBEX_CONF_OPTS += --with-usb=$(STAGING_DIR)
else
OPENOBEX_CONF_OPTS += --disable-usb
endif

$(eval $(autotools-package))
