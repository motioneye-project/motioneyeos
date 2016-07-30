################################################################################
#
# libopenh264
#
################################################################################

LIBOPENH264_VERSION = v1.5.0
LIBOPENH264_SITE = $(call github,cisco,openh264,$(LIBOPENH264_VERSION))
LIBOPENH264_LICENSE = BSD-2c
LIBOPENH264_LICENSE_FILES = LICENSE
LIBOPENH264_INSTALL_STAGING = YES

ifeq ($(BR2_aarch64),y)
LIBOPENH264_ARCH = aarch64
else ifeq ($(BR2_arm)$(BR2_armeb),y)
LIBOPENH264_ARCH = arm
else ifeq ($(BR2_i386),y)
LIBOPENH264_ARCH = x86
LIBOPENH264_DEPENDENCIES += host-nasm
else ifeq ($(BR2_mips)$(BR2_mipsel),y)
LIBOPENH264_ARCH = mips
else ifeq ($(BR2_mips64)$(BR2_mips64el),y)
LIBOPENH264_ARCH = mips64
else ifeq ($(BR2_x86_64),y)
LIBOPENH264_ARCH = x86_64
LIBOPENH264_DEPENDENCIES += host-nasm
endif

# ENABLE64BIT is really only used for x86-64, other 64 bits
# architecture don't need it.
LIBOPENH264_MAKE_OPTS = \
	ARCH=$(LIBOPENH264_ARCH) \
	ENABLE64BIT=$(if $(BR2_x86_64),Yes,No)

define LIBOPENH264_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		$(LIBOPENH264_MAKE_OPTS)
endef

define LIBOPENH264_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		$(LIBOPENH264_MAKE_OPTS) \
		DESTDIR=$(STAGING_DIR) PREFIX=/usr install
endef

define LIBOPENH264_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		$(LIBOPENH264_MAKE_OPTS) \
		DESTDIR=$(TARGET_DIR) PREFIX=/usr install
endef

$(eval $(generic-package))
