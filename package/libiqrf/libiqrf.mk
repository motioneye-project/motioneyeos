################################################################################
#
# libiqrf
#
################################################################################

LIBIQRF_VERSION = v0.1.2
LIBIQRF_SITE = $(call github,nandra,libiqrf,$(LIBIQRF_VERSION))
LIBIQRF_INSTALL_STAGING = YES

LIBIQRF_DEPENDENCIES = libusb

$(eval $(cmake-package))
