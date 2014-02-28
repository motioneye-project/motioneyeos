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

# arm specific asm optimizations
ifeq ($(BR2_arm),y)

ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
VO_AACENC_CONF_OPT += --enable-armv7neon
# mfpu=neon needed to assemble neon code
VO_AACENC_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -mfpu=neon"
else
VO_AACENC_CONF_OPT += --disable-armv7neon

ifeq ($(BR2_arm7tdmi)$(BR2_arm720t)$(BR2_arm920t)$(BR2_arm922t)$(BR2_strongarm)$(BR2_fa526),)
VO_AACENC_CONF_OPT += --enable-armv5e
else
VO_AACENC_CONF_OPT += --disable-armv5e
endif

endif # !neon
endif # arm

$(eval $(autotools-package))
