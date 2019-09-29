################################################################################
#
# imx-vpu-hantro
#
################################################################################

IMX_VPU_HANTRO_VERSION = 1.6.0
IMX_VPU_HANTRO_SITE = $(FREESCALE_IMX_SITE)
IMX_VPU_HANTRO_SOURCE = imx-vpu-hantro-$(IMX_VPU_HANTRO_VERSION).bin
IMX_VPU_HANTRO_DEPENDENCIES = linux
IMX_VPU_HANTRO_INSTALL_STAGING = YES

IMX_VPU_HANTRO_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	$(TARGET_CONFIGURE_OPTS) \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	SDKTARGETSYSROOT=$(STAGING_DIR) \
	LINUX_KERNEL_ROOT=$(LINUX_DIR)

IMX_VPU_HANTRO_LICENSE = NXP Semiconductor Software License Agreement
IMX_VPU_HANTRO_LICENSE_FILES = EULA COPYING
IMX_VPU_HANTRO_REDISTRIBUTE = NO

define IMX_VPU_HANTRO_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(IMX_VPU_HANTRO_DL_DIR)/$(IMX_VPU_HANTRO_SOURCE))
endef

define IMX_VPU_HANTRO_BUILD_CMDS
	$(IMX_VPU_HANTRO_MAKE_ENV) $(MAKE1) -C $(@D)
endef

define IMX_VPU_HANTRO_INSTALL_STAGING_CMDS
	$(IMX_VPU_HANTRO_MAKE_ENV) $(MAKE1) -C $(@D) \
		DEST_DIR=$(STAGING_DIR) libdir=/usr/lib install
endef

define IMX_VPU_HANTRO_INSTALL_TARGET_CMDS
	$(IMX_VPU_HANTRO_MAKE_ENV) $(MAKE1) -C $(@D) \
		DEST_DIR=$(TARGET_DIR) libdir=/usr/lib install
endef

$(eval $(generic-package))
