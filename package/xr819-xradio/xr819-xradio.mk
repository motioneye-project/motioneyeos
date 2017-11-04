################################################################################
#
# xr819-xradio
#
################################################################################

XR819_XRADIO_VERSION = c03a053a9e731d56c89c0c09627e886db2a0e04e
XR819_XRADIO_SITE = $(call github,fifteenhex,xradio,$(XR819_XRADIO_VERSION))
XR819_XRADIO_LICENSE = GPL-2.0
XR819_XRADIO_LICENSE_FILES = LICENSE

$(eval $(kernel-module))
$(eval $(generic-package))
