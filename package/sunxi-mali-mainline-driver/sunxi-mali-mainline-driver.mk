################################################################################
#
# sunxi-mali-mainline-driver
#
################################################################################

SUNXI_MALI_MAINLINE_DRIVER_VERSION = 52ef1c5e133cc5fd791ca636239dc5e7b19c26d5
SUNXI_MALI_MAINLINE_DRIVER_SITE = $(call github,mripard,sunxi-mali,$(SUNXI_MALI_MAINLINE_DRIVER_VERSION))
SUNXI_MALI_MAINLINE_DRIVER_DEPENDENCIES = linux

SUNXI_MALI_MAINLINE_DRIVER_MAKE_OPTS = \
	KDIR=$(LINUX_DIR) \
	CROSS_COMPILE=$(TARGET_CROSS) \
	INSTALL_MOD_PATH=$(TARGET_DIR)

define SUNXI_MALI_MAINLINE_DRIVER_USE_APPLY_PATCHES
	ln -sf $(SUNXI_MALI_MAINLINE_REV)/series $(@D)/patches
	$(SED) 's|quilt push -a|$(TOPDIR)/support/scripts/apply-patches.sh . ../patches|' \
		$(@D)/build.sh
endef

SUNXI_MALI_MAINLINE_DRIVER_POST_PATCH_HOOKS += SUNXI_MALI_MAINLINE_DRIVER_USE_APPLY_PATCHES

define SUNXI_MALI_MAINLINE_DRIVER_BUILD_CMDS
	cd $(@D) && $(SUNXI_MALI_MAINLINE_DRIVER_MAKE_OPTS) \
		$(SHELL) ./build.sh -r $(SUNXI_MALI_MAINLINE_REV) -j $(PARALLEL_JOBS) -b
endef

define SUNXI_MALI_MAINLINE_DRIVER_INSTALL_TARGET_CMDS
	cd $(@D) && $(SUNXI_MALI_MAINLINE_DRIVER_MAKE_OPTS) \
		$(SHELL) ./build.sh -r $(SUNXI_MALI_MAINLINE_REV) -j $(PARALLEL_JOBS) -i
endef

$(eval $(generic-package))
