################################################################################
#
# stm32flash
#
################################################################################

STM32FLASH_VERSION = 4ac0566f188f39eace0223d966d349cd2f2c5895
STM32FLASH_SITE = git://git.code.sf.net/p/stm32flash/code
STM32FLASH_LICENSE = GPL-2.0+
STM32FLASH_LICENSE_FILES = gpl-2.0.txt

define STM32FLASH_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define STM32FLASH_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) DESTDIR="$(TARGET_DIR)" PREFIX="/usr" \
		-C $(@D) install
endef

$(eval $(generic-package))
