################################################################################
#
# tegrarcm
#
################################################################################

TEGRARCM_VERSION = v1.7
TEGRARCM_SITE = $(call github,NVIDIA,tegrarcm,$(TEGRARCM_VERSION))
TEGRARCM_LICENSE = BSD-3c / NVIDIA Software License (src/miniloader)
TEGRARCM_LICENSE_FILE = LICENSE
TEGRARCM_AUTORECONF = YES
HOST_TEGRARCM_DEPENDENCIES = host-libusb host-pkgconf host-cryptopp

$(eval $(host-autotools-package))
