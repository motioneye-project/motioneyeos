################################################################################
#
# libraw1394
#
################################################################################

LIBRAW1394_VERSION = 2.0.7
LIBRAW1394_SOURCE = libraw1394-$(LIBRAW1394_VERSION).tar.xz
LIBRAW1394_SITE = $(BR2_KERNEL_MIRROR)/linux/libs/ieee1394
LIBRAW1394_INSTALL_STAGING = YES

$(eval $(autotools-package))
