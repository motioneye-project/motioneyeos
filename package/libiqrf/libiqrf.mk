################################################################################
#
# libiqrf
#
################################################################################

LIBIQRF_VERSION = 0.1.2
LIBIQRF_SITE = $(call github,nandra,libiqrf,v$(LIBIQRF_VERSION))
LIBIQRF_INSTALL_STAGING = YES
LIBIQRF_DEPENDENCIES = libusb
LIBIQRF_LICENSE = LGPL-2.1+

$(eval $(cmake-package))
