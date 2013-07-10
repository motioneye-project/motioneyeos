################################################################################
#
# libusb-compat
#
################################################################################

LIBUSB_COMPAT_VERSION = 0.1.4
LIBUSB_COMPAT_SOURCE = libusb-compat-$(LIBUSB_COMPAT_VERSION).tar.bz2
LIBUSB_COMPAT_SITE = http://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-$(LIBUSB_COMPAT_VERSION)
LIBUSB_COMPAT_DEPENDENCIES = host-pkgconf libusb
LIBUSB_COMPAT_INSTALL_STAGING = YES
LIBUSB_COMPAT_CONFIG_SCRIPTS = libusb-config
LIBUSB_COMPAT_LICENSE = LGPLv2.1+
LIBUSB_COMPAT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
$(eval $(host-autotools-package))
