################################################################################
#
# libusb-compat
#
################################################################################

LIBUSB_COMPAT_VERSION_MAJOR = 0.1
LIBUSB_COMPAT_VERSION = $(LIBUSB_COMPAT_VERSION_MAJOR).7
LIBUSB_COMPAT_SOURCE = libusb-compat-$(LIBUSB_COMPAT_VERSION).tar.bz2
LIBUSB_COMPAT_SITE = https://github.com/libusb/libusb-compat-0.1/releases/download/v$(LIBUSB_COMPAT_VERSION)
LIBUSB_COMPAT_DEPENDENCIES = host-pkgconf libusb
HOST_LIBUSB_COMPAT_DEPENDENCIES = host-pkgconf host-libusb
LIBUSB_COMPAT_INSTALL_STAGING = YES
LIBUSB_COMPAT_CONFIG_SCRIPTS = libusb-config
LIBUSB_COMPAT_LICENSE = LGPL-2.1+
LIBUSB_COMPAT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
$(eval $(host-autotools-package))
