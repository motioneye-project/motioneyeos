################################################################################
#
# afboot-stm32
#
################################################################################

AFBOOT_STM32_VERSION = v0.1
AFBOOT_STM32_SITE = $(call github,mcoquelin-stm32,afboot-stm32,$(AFBOOT_STM32_VERSION))

define AFBOOT_STM32_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) CROSS_COMPILE=$(TARGET_CROSS) all
endef

define AFBOOT_STM32_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/stm32*.bin $(BINARIES_DIR)
endef

$(eval $(generic-package))
