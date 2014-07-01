##########################################################################
#
# librtlsdr
#
##########################################################################

LIBRTLSDR_VERSION = v0.5.3
LIBRTLSDR_SITE = $(call github,steve-m,librtlsdr,$(LIBRTLSDR_VERSION))
LIBRTLSDR_LICENSE = GPLv2+
LIBRTLSDR_LICENSE_FILES = COPYING
LIBRTLSDR_INSTALL_STAGING = YES
LIBRTLSDR_DEPENDENCIES = libusb

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
LIBRTLSDR_CONF_OPT += -DINSTALL_UDEV_RULES=ON
endif

ifeq ($(BR2_PACKAGE_LIBRTLSDR_DETACH_DRIVER),y)
LIBRTLSDR_CONF_OPT += -DDETACH_KERNEL_DRIVER=1
endif

$(eval $(cmake-package))
