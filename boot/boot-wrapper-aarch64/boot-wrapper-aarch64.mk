################################################################################
#
# boot-wrapper-aarch64
#
################################################################################

BOOT_WRAPPER_AARCH64_VERSION        = 26b62f586020fd998c6efd43db657eaafeec14da
BOOT_WRAPPER_AARCH64_SITE           = git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/boot-wrapper-aarch64.git
BOOT_WRAPPER_AARCH64_LICENSE        = BSD3c
BOOT_WRAPPER_AARCH64_LICENSE_FILES  = LICENSE.txt
BOOT_WRAPPER_AARCH64_DEPENDENCIES   = linux
BOOT_WRAPPER_AARCH64_INSTALL_IMAGES = YES

BOOT_WRAPPER_AARCH64_DTS = $(call qstrip,$(BR2_TARGET_BOOT_WRAPPER_AARCH64_DTS))

define BOOT_WRAPPER_AARCH64_BUILD_CMDS
	$(MAKE) \
		KERNEL=$(BINARIES_DIR)/Image \
		DTC=$(LINUX_DIR)/scripts/dtc/dtc \
		FDT_SRC=$(LINUX_DIR)/arch/arm64/boot/dts/$(BOOT_WRAPPER_AARCH64_DTS).dts \
		CROSS_COMPILE="$(CCACHE) $(TARGET_CROSS)" \
		BOOTARGS='$(BR2_TARGET_BOOT_WRAPPER_AARCH64_BOOTARGS)' -C $(@D)
endef

define BOOT_WRAPPER_AARCH64_INSTALL_IMAGES_CMDS
	cp $(@D)/linux-system.axf $(BINARIES_DIR)
endef

$(eval $(generic-package))
