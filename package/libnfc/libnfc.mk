################################################################################
#
# libnfc
#
################################################################################

LIBNFC_VERSION = fda8d60ce062
LIBNFC_SITE = http://libnfc.googlecode.com/git/
LIBNFC_SITE_METHOD = git
LIBNFC_LICENSE = LGPLv3+
LIBNFC_LICENSE_FILES = COPYING
LIBNFC_AUTORECONF = YES
LIBNFC_INSTALL_STAGING = YES

LIBNFC_DEPENDENCIES = host-pkgconf libusb libusb-compat

# N.B. The acr122 driver requires pcsc-lite.
LIBNFC_CONF_OPT = --with-drivers=arygon,pn53x_usb

ifeq ($(BR2_PACKAGE_LIBNFC_EXAMPLES),y)
LIBNFC_CONF_OPT += --enable-example
LIBNFC_DEPENDENCIES += readline
else
LIBNFC_CONF_OPT += --disable-example
endif

$(eval $(autotools-package))
