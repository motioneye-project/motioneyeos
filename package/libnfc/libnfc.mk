################################################################################
#
# libnfc
#
################################################################################

LIBNFC_VERSION = 1.7.1
LIBNFC_SOURCE = libnfc-$(LIBNFC_VERSION).tar.bz2
LIBNFC_SITE = https://github.com/nfc-tools/libnfc/releases/download/libnfc-$(LIBNFC_VERSION)
LIBNFC_LICENSE = LGPL-3.0+
LIBNFC_LICENSE_FILES = COPYING
LIBNFC_AUTORECONF = YES
LIBNFC_INSTALL_STAGING = YES

LIBNFC_DEPENDENCIES = host-pkgconf

# N.B. The acr122 driver requires pcsc-lite.
ifeq ($(BR2_PACKAGE_LIBNFC_ACR122_PCSC),y)
LIBNFC_DRIVER_LIST += acr122_pcsc
LIBNFC_DEPENDENCIES += pcsc-lite
endif

ifeq ($(BR2_PACKAGE_LIBNFC_ACR122_USB),y)
LIBNFC_DRIVER_LIST += acr122_usb
LIBNFC_DEPENDENCIES += libusb libusb-compat
endif

ifeq ($(BR2_PACKAGE_LIBNFC_ACR122S),y)
LIBNFC_DRIVER_LIST += acr122s
endif

ifeq ($(BR2_PACKAGE_LIBNFC_ARYGON),y)
LIBNFC_DRIVER_LIST += arygon
endif

ifeq ($(BR2_PACKAGE_LIBNFC_PN532_I2C),y)
LIBNFC_DRIVER_LIST += pn532_i2c
endif

ifeq ($(BR2_PACKAGE_LIBNFC_PN532_SPI),y)
LIBNFC_DRIVER_LIST += pn532_spi
endif

ifeq ($(BR2_PACKAGE_LIBNFC_PN532_UART),y)
LIBNFC_DRIVER_LIST += pn532_uart
endif

ifeq ($(BR2_PACKAGE_LIBNFC_PN53X_USB),y)
LIBNFC_DRIVER_LIST += pn53x_usb
LIBNFC_DEPENDENCIES += libusb libusb-compat
endif

LIBNFC_CONF_OPTS = \
	--with-drivers=$(subst $(space),$(comma),$(strip $(LIBNFC_DRIVER_LIST)))

ifeq ($(BR2_PACKAGE_LIBNFC_EXAMPLES),y)
LIBNFC_CONF_OPTS += --enable-example
LIBNFC_DEPENDENCIES += readline
else
LIBNFC_CONF_OPTS += --disable-example
endif

$(eval $(autotools-package))
