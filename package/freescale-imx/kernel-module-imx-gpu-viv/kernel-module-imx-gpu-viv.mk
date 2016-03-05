################################################################################
#
# kernel-module-imx-gpu-viv
#
################################################################################

KERNEL_MODULE_IMX_GPU_VIV_VERSION = eeeb23c0fb1cee01318088d417025263479c44ac
KERNEL_MODULE_IMX_GPU_VIV_SITE = \
	$(call github,Freescale,kernel-module-imx-gpu-viv,$(KERNEL_MODULE_IMX_GPU_VIV_VERSION))
KERNEL_MODULE_IMX_GPU_VIV_LICENSE = GPLv2
KERNEL_MODULE_IMX_GPU_VIV_LICENSE_FILES = COPYING

KERNEL_MODULE_IMX_GPU_VIV_MODULE_MAKE_OPTS = \
	AQROOT=$(@D)/kernel-module-imx-gpu-viv-src \
	KERNEL_DIR=$(LINUX_DIR)

KERNEL_MODULE_IMX_GPU_VIV_MODULE_SUBDIRS = kernel-module-imx-gpu-viv-src

$(eval $(kernel-module))
$(eval $(generic-package))
