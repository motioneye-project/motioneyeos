################################################################################
#
# afboot-stm32
#
################################################################################

AFBOOT_STM32_VERSION = 0.2
AFBOOT_STM32_SITE = $(call github,mcoquelin-stm32,afboot-stm32,v$(AFBOOT_STM32_VERSION))
AFBOOT_STM32_INSTALL_IMAGES = YES
AFBOOT_STM32_INSTALL_TARGET = NO

define AFBOOT_STM32_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) CROSS_COMPILE=$(TARGET_CROSS) all
endef

define AFBOOT_STM32_INSTALL_IMAGES_CMDS
	$(INSTALL) -m 0755 -t $(BINARIES_DIR) -D $(@D)/stm32*.bin
endef

$(eval $(generic-package))
