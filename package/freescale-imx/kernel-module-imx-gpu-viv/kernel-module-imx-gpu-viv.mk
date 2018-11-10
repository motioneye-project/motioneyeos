################################################################################
#
# kernel-module-imx-gpu-viv
#
################################################################################

KERNEL_MODULE_IMX_GPU_VIV_VERSION = 3b9e057f29853fd29364aa666328a92b807007d7
KERNEL_MODULE_IMX_GPU_VIV_SITE = \
	$(call github,Freescale,kernel-module-imx-gpu-viv,$(KERNEL_MODULE_IMX_GPU_VIV_VERSION))
KERNEL_MODULE_IMX_GPU_VIV_LICENSE = GPL-2.0
KERNEL_MODULE_IMX_GPU_VIV_LICENSE_FILES = COPYING

KERNEL_MODULE_IMX_GPU_VIV_MODULE_MAKE_OPTS = \
	AQROOT=$(@D)/kernel-module-imx-gpu-viv-src \
	KERNEL_DIR=$(LINUX_DIR)

KERNEL_MODULE_IMX_GPU_VIV_MODULE_SUBDIRS = kernel-module-imx-gpu-viv-src

$(eval $(kernel-module))
$(eval $(generic-package))
