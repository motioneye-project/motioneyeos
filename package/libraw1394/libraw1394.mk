################################################################################
#
# libraw1394
#
################################################################################

LIBRAW1394_VERSION = 2.1.1
LIBRAW1394_SOURCE = libraw1394-$(LIBRAW1394_VERSION).tar.xz
LIBRAW1394_SITE = $(BR2_KERNEL_MIRROR)/linux/libs/ieee1394
LIBRAW1394_PATCH = http://git.alpinelinux.org/cgit/aports/plain/main/libraw1394/fix-types.patch
LIBRAW1394_INSTALL_STAGING = YES
LIBRAW1394_LICENSE = LGPL-2.1+
LIBRAW1394_LICENSE_FILES = COPYING.LIB

$(eval $(autotools-package))
