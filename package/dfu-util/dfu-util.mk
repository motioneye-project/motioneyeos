################################################################################
#
# dfu-util
#
################################################################################

DFU_UTIL_VERSION = 0.6
DFU_UTIL_SITE = http://dfu-util.gnumonks.org/releases
DFU_UTIL_LICENSE = GPLv2+
DFU_UTIL_LICENSE_FILES = COPYING

HOST_DFU_UTIL_DEPENDENCIES = host-libusb

$(eval $(host-autotools-package))
