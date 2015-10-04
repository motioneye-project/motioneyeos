################################################################################
#
# vo-aacenc
#
################################################################################

VO_AACENC_VERSION = 0.1.3
VO_AACENC_SITE = http://downloads.sourceforge.net/project/opencore-amr/vo-aacenc
VO_AACENC_LICENSE = Apache-2.0
VO_AACENC_LICENSE_FILES = COPYING
VO_AACENC_INSTALL_STAGING = YES

VO_AACENC_CFLAGS = $(TARGET_CFLAGS)

# arm specific asm optimizations
ifeq ($(BR2_arm),y)

# vo-aacenc has ARM assembly code that cannot be compiled in Thumb2
# mode, so we must force the traditional ARM mode.
VO_AACENC_CFLAGS += -marm

ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
VO_AACENC_CONF_OPTS += --enable-armv7neon
# mfpu=neon needed to assemble neon code
VO_AACENC_CFLAGS += -mfpu=neon
else
VO_AACENC_CONF_OPTS += --disable-armv7neon

ifeq ($(BR2_ARM_CPU_ARMV4),)
VO_AACENC_CONF_OPTS += --enable-armv5e
else
VO_AACENC_CONF_OPTS += --disable-armv5e
endif

endif # !neon
endif # arm

VO_AACENC_CONF_ENV = \
	CFLAGS="$(VO_AACENC_CFLAGS)"

$(eval $(autotools-package))
