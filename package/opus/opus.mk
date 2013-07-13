################################################################################
#
# opus
#
################################################################################

OPUS_VERSION = 1.0.3
OPUS_SITE = http://downloads.xiph.org/releases/opus
OPUS_INSTALL_STAGING = YES
OPUS_CONF_OPT = --disable-doc

ifeq ($(BR2_SOFT_FLOAT),y)
OPUS_CONF_OPT += --enable-fixed-point
endif

$(eval $(autotools-package))
