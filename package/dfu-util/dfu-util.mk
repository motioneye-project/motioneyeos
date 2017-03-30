################################################################################
#
# dfu-util
#
################################################################################

DFU_UTIL_VERSION = 0.9
DFU_UTIL_SITE = http://dfu-util.sourceforge.net/releases
DFU_UTIL_LICENSE = GPL-2.0+
DFU_UTIL_LICENSE_FILES = COPYING

HOST_DFU_UTIL_DEPENDENCIES = host-libusb

$(eval $(host-autotools-package))
