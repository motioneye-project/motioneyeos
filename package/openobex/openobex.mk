################################################################################
#
# openobex
#
################################################################################

OPENOBEX_VERSION = 1.7.2
OPENOBEX_SITE = http://downloads.sourceforge.net/project/openobex/openobex/$(OPENOBEX_VERSION)
OPENOBEX_SOURCE = openobex-$(OPENOBEX_VERSION)-Source.tar.gz
# Libraries seems to be released under LGPL-2.1+,
# while other material is under GPL-2.0+.
OPENOBEX_LICENSE = GPL-2.0+/LGPL-2.1+
OPENOBEX_LICENSE_FILES = COPYING COPYING.LIB
OPENOBEX_DEPENDENCIES = host-pkgconf
OPENOBEX_INSTALL_STAGING = YES
OPENOBEX_CONF_OPTS = -DBUILD_DOCUMENTATION=OFF

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS),y)
OPENOBEX_DEPENDENCIES += bluez5_utils
endif

ifeq ($(BR2_PACKAGE_LIBUSB),y)
OPENOBEX_DEPENDENCIES += libusb
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
OPENOBEX_DEPENDENCIES += udev
endif

$(eval $(cmake-package))
