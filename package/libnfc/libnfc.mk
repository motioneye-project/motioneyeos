#############################################################
#
# libnfc
#
#############################################################
LIBNFC_VERSION = 1.5.1
LIBNFC_SITE = http://libnfc.googlecode.com/files/
LIBNFC_SOURCE = libnfc-$(LIBNFC_VERSION).tar.gz
LIBNFC_AUTORECONF = YES
LIBNFC_INSTALL_STAGING = YES

LIBNFC_DEPENDENCIES = host-pkg-config libusb libusb-compat

# N.B. The acr122 driver requires pcsc-lite.
LIBNFC_CONF_OPT = --with-drivers=arygon,pn53x_usb

ifeq ($(BR2_PACKAGE_LIBNFC_EXAMPLES),y)
LIBNFC_CONF_OPT += --enable-example
LIBNFC_DEPENDENCIES += readline
else
LIBNFC_CONF_OPT += --disable-example
endif

$(eval $(call AUTOTARGETS))
