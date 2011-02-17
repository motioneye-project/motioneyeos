#############################################################
#
# libusb
#
#############################################################
LIBUSB_VERSION = 1.0.8
LIBUSB_SOURCE = libusb-$(LIBUSB_VERSION).tar.bz2
LIBUSB_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/project/libusb/libusb-1.0/libusb-$(LIBUSB_VERSION)
LIBUSB_DEPENDENCIES = host-pkg-config
LIBUSB_INSTALL_STAGING = YES
LIBUSB_INSTALL_TARGET = YES

$(eval $(call AUTOTARGETS,package,libusb))
