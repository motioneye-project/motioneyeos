################################################################################
#
# qdecoder
#
################################################################################

QDECODER_VERSION = 12.0.7
QDECODER_SITE = $(call github,wolkykim,qdecoder,v$(QDECODER_VERSION))
QDECODER_LICENSE = BSD-2
QDECODER_LICENSE_FILES = COPYING
QDECODER_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'

QDECODER_INSTALL_STAGING = YES

$(eval $(autotools-package))
