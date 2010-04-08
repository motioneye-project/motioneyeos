#############################################################
#
# libusb-compat
#
#############################################################
LIBUSB_COMPAT_VERSION = 0.1.3
LIBUSB_COMPAT_SOURCE = libusb-compat-$(LIBUSB_COMPAT_VERSION).tar.bz2
LIBUSB_COMPAT_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-$(LIBUSB_COMPAT_VERSION)
LIBUSB_COMPAT_LIBTOOL_PATCH = NO
LIBUSB_COMPAT_DEPENDENCIES = host-pkg-config libusb
LIBUSB_COMPAT_INSTALL_STAGING = YES
LIBUSB_COMPAT_INSTALL_TARGET = YES

$(eval $(call AUTOTARGETS,package,libusb-compat))
