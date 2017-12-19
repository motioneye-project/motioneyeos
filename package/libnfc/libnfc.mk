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

LIBNFC_DEPENDENCIES = host-pkgconf libusb libusb-compat

# N.B. The acr122 driver requires pcsc-lite.
LIBNFC_CONF_OPTS = --with-drivers=arygon,pn53x_usb

ifeq ($(BR2_PACKAGE_LIBNFC_EXAMPLES),y)
LIBNFC_CONF_OPTS += --enable-example
LIBNFC_DEPENDENCIES += readline
else
LIBNFC_CONF_OPTS += --disable-example
endif

$(eval $(autotools-package))
