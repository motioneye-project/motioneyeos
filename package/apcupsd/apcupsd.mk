################################################################################
#
# apcupsd
#
################################################################################

APCUPSD_VERSION = 3.14.14
APCUPSD_SITE = http://downloads.sourceforge.net/project/apcupsd/apcupsd%20-%20Stable/$(APCUPSD_VERSION)
APCUPSD_LICENSE = GPL-2.0
APCUPSD_LICENSE_FILES = COPYING
APCUPSD_CONF_OPTS = --disable-test

ifeq ($(BR2_PACKAGE_LIBUSB_COMPAT),y)
APCUPSD_CONF_ENV = ac_cv_path_usbcfg=$(STAGING_DIR)/usr/bin/libusb-config
endif

ifeq ($(BR2_PACKAGE_APCUPSD_APCSMART),y)
APCUPSD_CONF_OPTS += --enable-apcsmart
else
APCUPSD_CONF_OPTS += --disable-apcsmart
endif

ifeq ($(BR2_PACKAGE_APCUPSD_DUMB),y)
APCUPSD_CONF_OPTS += --enable-dumb
else
APCUPSD_CONF_OPTS += --disable-dumb
endif

ifeq ($(BR2_PACKAGE_APCUPSD_MODBUS_USB),y)
APCUPSD_CONF_OPTS += --enable-modbus-usb
APCUPSD_DEPENDENCIES = libusb libusb-compat
else
APCUPSD_CONF_OPTS += --disable-modbus-usb
endif

ifeq ($(BR2_PACKAGE_APCUPSD_MODBUS),y)
APCUPSD_CONF_OPTS += --enable-modbus
else
APCUPSD_CONF_OPTS += --disable-modbus
endif

ifeq ($(BR2_PACKAGE_APCUPSD_NET),y)
APCUPSD_CONF_OPTS += --enable-net
else
APCUPSD_CONF_OPTS += --disable-net
endif

ifeq ($(BR2_PACKAGE_APCUPSD_PCNET),y)
APCUPSD_CONF_OPTS += --enable-pcnet
else
APCUPSD_CONF_OPTS += --disable-pcnet
endif

ifeq ($(BR2_PACKAGE_APCUPSD_SNMP),y)
APCUPSD_CONF_OPTS += --enable-snmp
else
APCUPSD_CONF_OPTS += --disable-snmp
endif

ifeq ($(BR2_PACKAGE_APCUPSD_USB),y)
APCUPSD_CONF_OPTS += --enable-usb
APCUPSD_DEPENDENCIES = libusb libusb-compat
else
APCUPSD_CONF_OPTS += --disable-usb
endif

$(eval $(autotools-package))
