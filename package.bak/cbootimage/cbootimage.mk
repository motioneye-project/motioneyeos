################################################################################
#
# cbootimage
#
################################################################################

CBOOTIMAGE_VERSION = v1.7
CBOOTIMAGE_SITE = $(call github,NVIDIA,cbootimage,$(CBOOTIMAGE_VERSION))
CBOOTIMAGE_LICENSE = GPLv2
CBOOTIMAGE_LICENSE_FILES = COPYING
CBOOTIMAGE_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))

