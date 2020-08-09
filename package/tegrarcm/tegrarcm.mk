################################################################################
#
# tegrarcm
#
################################################################################

TEGRARCM_VERSION = 1.8
TEGRARCM_SITE = $(call github,NVIDIA,tegrarcm,v$(TEGRARCM_VERSION))
TEGRARCM_LICENSE = BSD-3-Clause / NVIDIA Software License (src/miniloader)
TEGRARCM_LICENSE_FILES = LICENSE
TEGRARCM_AUTORECONF = YES
HOST_TEGRARCM_DEPENDENCIES = host-libusb host-pkgconf host-cryptopp

$(eval $(host-autotools-package))
