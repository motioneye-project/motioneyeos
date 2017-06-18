################################################################################
#
# xr819-xradio
#
################################################################################

XR819_XRADIO_VERSION = 014dfdd203102c5fd2370a73ec4ae3e6dd4e9ded
XR819_XRADIO_SITE = $(call github,fifteenhex,xradio,$(XR819_XRADIO_VERSION))
XR819_XRADIO_LICENSE = GPL-2.0
XR819_XRADIO_LICENSE_FILES = LICENSE

$(eval $(kernel-module))
$(eval $(generic-package))
