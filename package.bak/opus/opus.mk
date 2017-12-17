################################################################################
#
# opus
#
################################################################################

OPUS_VERSION = 1.1.4
OPUS_SITE = http://downloads.xiph.org/releases/opus
OPUS_LICENSE = BSD-3c
OPUS_LICENSE_FILES = COPYING
OPUS_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_OPUS_FIXED_POINT),y)
OPUS_CONF_OPTS += --enable-fixed-point
endif

# When we're on ARM, but we don't have ARM instructions (only
# Thumb-2), disable the usage of assembly as it is not Thumb-ready.
ifeq ($(BR2_arm)$(BR2_armeb):$(BR2_ARM_CPU_HAS_ARM),y:)
OPUS_CONF_OPTS += --disable-asm
endif

$(eval $(autotools-package))
