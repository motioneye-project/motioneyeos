################################################################################
#
# sunxi-mali-mainline-driver
#
################################################################################

SUNXI_MALI_MAINLINE_DRIVER_VERSION = 42c7c139c14103a83bb2ad7e7a1f0ed491f96500
SUNXI_MALI_MAINLINE_DRIVER_SITE = $(call github,mripard,sunxi-mali,$(SUNXI_MALI_MAINLINE_DRIVER_VERSION))
SUNXI_MALI_MAINLINE_DRIVER_DEPENDENCIES = linux

SUNXI_MALI_MAINLINE_DRIVER_MAKE_OPTS = \
	KDIR=$(LINUX_DIR) \
	CROSS_COMPILE=$(TARGET_CROSS) \
	INSTALL_MOD_PATH=$(TARGET_DIR)

define SUNXI_MALI_MAINLINE_DRIVER_BUILD_CMDS
	cd $(@D) && $(SUNXI_MALI_MAINLINE_DRIVER_MAKE_OPTS) \
		$(SHELL) ./build.sh -r $(SUNXI_MALI_MAINLINE_REV) -b
endef

define SUNXI_MALI_MAINLINE_DRIVER_INSTALL_TARGET_CMDS
	cd $(@D) && $(SUNXI_MALI_MAINLINE_DRIVER_MAKE_OPTS) \
		$(SHELL) ./build.sh -r $(SUNXI_MALI_MAINLINE_REV) -i
endef

$(eval $(generic-package))
