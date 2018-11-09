################################################################################
#
# gst1-imx
#
################################################################################

GST1_IMX_VERSION = 0.13.0
GST1_IMX_SITE = $(call github,Freescale,gstreamer-imx,$(GST1_IMX_VERSION))

GST1_IMX_LICENSE = LGPL-2.0+
GST1_IMX_LICENSE_FILES = LICENSE

GST1_IMX_INSTALL_STAGING = YES

GST1_IMX_DEPENDENCIES += \
	host-pkgconf \
	gstreamer1 \
	gst1-plugins-base

GST1_IMX_CONF_OPTS = --prefix="/usr"

ifeq ($(BR2_LINUX_KERNEL),y)
# IPU and PXP need access to imx-specific kernel headers
GST1_IMX_DEPENDENCIES += linux
GST1_IMX_CONF_OPTS += --kernel-headers="$(LINUX_DIR)/include"
endif

ifeq ($(BR2_PACKAGE_IMX_CODEC),y)
GST1_IMX_DEPENDENCIES += imx-codec
endif

ifeq ($(BR2_PACKAGE_IMX_GPU_VIV),y)
GST1_IMX_DEPENDENCIES += imx-gpu-viv
endif

ifeq ($(BR2_PACKAGE_IMX_GPU_G2D),y)
GST1_IMX_DEPENDENCIES += imx-gpu-g2d
endif

ifeq ($(BR2_PACKAGE_GST1_IMX_EGLVISINK),y)
# There's no --enable-eglvivsink option
ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
GST1_IMX_DEPENDENCIES += xlib_libX11
GST1_IMX_CONF_OPTS += --egl-platform=x11
else
ifeq ($(BR2_PACKAGE_WAYLAND),y)
GST1_IMX_DEPENDENCIES += wayland
GST1_IMX_CONF_OPTS += --egl-platform=wayland
else
GST1_IMX_CONF_OPTS += --egl-platform=fb
endif
endif
else
GST1_IMX_CONF_OPTS += --disable-eglvivsink
endif

# There's no --enable-g2d option
ifeq ($(BR2_PACKAGE_GST1_IMX_G2D),)
GST1_IMX_CONF_OPTS += --disable-g2d
endif

# There's no --enable-ipu option
ifeq ($(BR2_PACKAGE_GST1_IMX_IPU),)
GST1_IMX_CONF_OPTS += --disable-ipu
endif

# There's no --enable-mp3encoder option
ifeq ($(BR2_PACKAGE_GST1_IMX_MP3ENCODER),)
GST1_IMX_CONF_OPTS += --disable-mp3encoder
endif

# There's no --enable-pxp option
ifeq ($(BR2_PACKAGE_GST1_IMX_PXP),)
GST1_IMX_CONF_OPTS += --disable-pxp
endif

# There's no --enable-uniaudiodec option
ifeq ($(BR2_PACKAGE_GST1_IMX_UNIAUDIODEC),)
GST1_IMX_CONF_OPTS += --disable-uniaudiodec
endif

ifeq ($(BR2_PACKAGE_GST1_IMX_VPU),y)
# There's no --enable-vpu option
GST1_IMX_DEPENDENCIES += libimxvpuapi
else
GST1_IMX_CONF_OPTS += --disable-vpu
endif

ifeq ($(BR2_PACKAGE_GST1_IMX_V4L2VIDEOSRC),y)
# There's no --enable-imxv4l2videosrc option
GST1_IMX_DEPENDENCIES += gst1-plugins-bad
else
GST1_IMX_CONF_OPTS += --disable-imxv4l2videosrc
endif

ifeq ($(BR2_PACKAGE_GST1_IMX_V4L2VIDEOSINK),y)
# There's no --enable-imxv4l2videosink option
GST1_IMX_DEPENDENCIES += gst1-plugins-bad
else
GST1_IMX_CONF_OPTS += --disable-imxv4l2videosink
endif

$(eval $(waf-package))
