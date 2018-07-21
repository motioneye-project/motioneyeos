################################################################################
#
# xdriver_xf86-video-imx-viv
#
################################################################################

XDRIVER_XF86_VIDEO_IMX_VIV_VERSION = rel_imx_4.9.x_1.0.0_ga
XDRIVER_XF86_VIDEO_IMX_VIV_SITE = https://source.codeaurora.org/external/imx/xf86-video-imx-vivante
XDRIVER_XF86_VIDEO_IMX_VIV_SITE_METHOD = git
XDRIVER_XF86_VIDEO_IMX_VIV_DEPENDENCIES = imx-gpu-viv imx-gpu-g2d xserver_xorg-server \
	xorgproto libdrm
XDRIVER_XF86_VIDEO_IMX_VIV_LICENSE = MIT
XDRIVER_XF86_VIDEO_IMX_VIV_LICENSE_FILES = COPYING-MIT
XDRIVER_XF86_VIDEO_IMX_VIV_INSTALL_STAGING = YES
XDRIVER_XF86_VIDEO_IMX_VIV_MAKE_CMD = $(TARGET_CONFIGURE_OPTS) $(MAKE1) -C $(@D)/EXA/src -f makefile.linux

define XDRIVER_XF86_VIDEO_IMX_VIV_BUILD_CMDS
	$(XDRIVER_XF86_VIDEO_IMX_VIV_MAKE_CMD) sysroot=$(STAGING_DIR) \
		BUSID_HAS_NUMBER=1 BUILD_IN_YOCTO=1 XSERVER_GREATER_THAN_13=1 \
		CFLAGS="$(TARGET_CFLAGS)"
endef

define XDRIVER_XF86_VIDEO_IMX_VIV_INSTALL_STAGING_CMDS
	$(XDRIVER_XF86_VIDEO_IMX_VIV_MAKE_CMD) prefix=$(STAGING_DIR)/usr install
	$(INSTALL) -D -m 644 $(@D)/EXA/src/vivante_gal/vivante_priv.h \
		$(STAGING_DIR)/usr/include/vivante_priv.h
	$(INSTALL) -D -m 644 $(@D)/EXA/src/vivante_gal/vivante_gal.h \
		$(STAGING_DIR)/usr/include/vivante_gal.h
endef

define XDRIVER_XF86_VIDEO_IMX_VIV_INSTALL_TARGET_CMDS
	$(XDRIVER_XF86_VIDEO_IMX_VIV_MAKE_CMD) prefix=$(TARGET_DIR)/usr install
endef

$(eval $(generic-package))
