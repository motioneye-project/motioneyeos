################################################################################
#
# imx-vpu
#
################################################################################

IMX_VPU_VERSION = 5.4.31
IMX_VPU_SITE = $(FREESCALE_IMX_SITE)
IMX_VPU_SOURCE = imx-vpu-$(IMX_VPU_VERSION).bin

IMX_VPU_INSTALL_STAGING = YES

IMX_VPU_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	$(TARGET_CONFIGURE_OPTS) \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	PLATFORM=$(BR2_PACKAGE_FREESCALE_IMX_PLATFORM)

IMX_VPU_LICENSE = Freescale Semiconductor Software License Agreement
IMX_VPU_LICENSE_FILES = EULA COPYING
IMX_VPU_REDISTRIBUTE = NO

define IMX_VPU_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(DL_DIR)/$(IMX_VPU_SOURCE))
endef

define IMX_VPU_BUILD_CMDS
	$(IMX_VPU_MAKE_ENV) $(MAKE1) -C $(@D)
endef

define IMX_VPU_INSTALL_STAGING_CMDS
	$(IMX_VPU_MAKE_ENV) $(MAKE1) -C $(@D) DEST_DIR=$(STAGING_DIR) install
endef

define IMX_VPU_INSTALL_TARGET_CMDS
	$(IMX_VPU_MAKE_ENV) $(MAKE1) -C $(@D) DEST_DIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
