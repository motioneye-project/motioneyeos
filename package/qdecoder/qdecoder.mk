################################################################################
#
# qdecoder
#
################################################################################

QDECODER_VERSION = r12.0.5
QDECODER_SITE = $(call github,wolkykim,qdecoder,$(QDECODER_VERSION))
QDECODER_LICENSE = BSD-2
QDECODER_LICENSE_FILES = COPYING
# we patch configure.ac
QDECODER_AUTORECONF = YES
QDECODER_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'

QDECODER_INSTALL_STAGING = YES

$(eval $(autotools-package))
