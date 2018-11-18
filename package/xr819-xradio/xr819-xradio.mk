################################################################################
#
# xr819-xradio
#
################################################################################

XR819_XRADIO_VERSION = 33f4b1c25eff0d9db7cbac19f36b130da9857f37
XR819_XRADIO_SITE = $(call github,fifteenhex,xradio,$(XR819_XRADIO_VERSION))
XR819_XRADIO_LICENSE = GPL-2.0
XR819_XRADIO_LICENSE_FILES = LICENSE

$(eval $(kernel-module))
$(eval $(generic-package))
