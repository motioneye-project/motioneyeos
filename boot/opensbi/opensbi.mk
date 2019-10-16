################################################################################
#
# opensbi
#
################################################################################

OPENSBI_VERSION = 0.5
OPENSBI_SITE = $(call github,riscv,opensbi,v$(OPENSBI_VERSION))
OPENSBI_LICENSE = BSD-2-Clause
OPENSBI_LICENSE_FILES = COPYING.BSD
OPENSBI_INSTALL_TARGET = NO
OPENSBI_INSTALL_STAGING = YES

OPENSBI_MAKE_ENV = \
	CROSS_COMPILE=$(TARGET_CROSS)

OPENSBI_PLAT = $(call qstrip,$(BR2_TARGET_OPENSBI_PLAT))
ifneq ($(OPENSBI_PLAT),)
OPENSBI_MAKE_ENV += PLATFORM=$(OPENSBI_PLAT)
endif

ifeq ($(BR2_TARGET_OPENSBI_LINUX_PAYLOAD),y)
OPENSBI_DEPENDENCIES += linux
OPENSBI_MAKE_ENV += FW_PAYLOAD_PATH="$(BINARIES_DIR)/Image"
endif

define OPENSBI_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(OPENSBI_MAKE_ENV) $(MAKE) -C $(@D)
endef

ifneq ($(OPENSBI_PLAT),)
OPENSBI_INSTALL_IMAGES = YES
OPENSBI_FW_IMAGES += jump dynamic
ifeq ($(BR2_TARGET_OPENSBI_LINUX_PAYLOAD),y)
OPENSBI_FW_IMAGES += payload
endif
endif

define OPENSBI_INSTALL_IMAGES_CMDS
	$(foreach f,$(OPENSBI_FW_IMAGES),\
		$(INSTALL) -m 0644 -D $(@D)/build/platform/$(OPENSBI_PLAT)/firmware/fw_$(f).bin \
			$(BINARIES_DIR)/fw_$(f).bin
		$(INSTALL) -m 0644 -D $(@D)/build/platform/$(OPENSBI_PLAT)/firmware/fw_$(f).elf \
			$(BINARIES_DIR)/fw_$(f).elf
	)
endef

# libsbi.a is not a library meant to be linked in user-space code, but
# with bare metal code, which is why we don't install it in
# $(STAGING_DIR)/usr/lib
define OPENSBI_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0644 -D $(@D)/build/lib/libsbi.a $(STAGING_DIR)/usr/share/opensbi/libsbi.a
endef

$(eval $(generic-package))
