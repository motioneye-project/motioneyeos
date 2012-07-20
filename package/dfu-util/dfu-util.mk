#############################################################
#
# dfu-util
#
#############################################################
DFU_UTIL_VERSION = 0.6
DFU_UTIL_SOURCE = dfu-util-$(DFU_UTIL_VERSION).tar.gz
DFU_UTIL_SITE = http://dfu-util.gnumonks.org/releases/

HOST_DFU_UTIL_DEPENDENCIES = host-libusb

$(eval $(host-autotools-package))

