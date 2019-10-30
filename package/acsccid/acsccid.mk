################################################################################
#
# acsccid
#
################################################################################

ACSCCID_VERSION = 1.1.7
ACSCCID_SOURCE = acsccid-$(ACSCCID_VERSION).tar.bz2
ACSCCID_SITE = http://downloads.sourceforge.net/acsccid
ACSCCID_LICENSE = LGPL-2.1+
ACSCCID_LICENSE_FILES = COPYING
ACSCCID_INSTALL_STAGING = YES
ACSCCID_DEPENDENCIES = pcsc-lite host-flex host-pkgconf libusb
ACSCCID_CONF_OPTS = --enable-usbdropdir=/usr/lib/pcsc/drivers

ifeq ($(BR2_PACKAGE_LIBICONV),y)
ACSCCID_DEPENDENCIES += libiconv
endif

$(eval $(autotools-package))
