################################################################################
#
# xr819-xradio
#
################################################################################

XR819_XRADIO_VERSION = aa01ba77b9360dd734b50f5b937960a50c5a0825
XR819_XRADIO_SITE = $(call github,fifteenhex,xradio,$(XR819_XRADIO_VERSION))
XR819_XRADIO_LICENSE = GPL-2.0
XR819_XRADIO_LICENSE_FILES = LICENSE

$(eval $(kernel-module))
$(eval $(generic-package))
