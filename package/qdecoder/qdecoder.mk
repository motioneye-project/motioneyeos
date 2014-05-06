################################################################################
#
# qdecoder
#
################################################################################

QDECODER_VERSION = r12.0.5
QDECODER_SITE = $(call github,wolkykim,qdecoder,$(QDECODER_VERSION))
QDECODER_LICENSE = BSD-2
QDECODER_LICENSE_FILES = COPYING

QDECODER_INSTALL_STAGING = YES

$(eval $(autotools-package))
