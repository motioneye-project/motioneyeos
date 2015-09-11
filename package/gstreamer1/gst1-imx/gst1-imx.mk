################################################################################
#
# gst1-imx
#
################################################################################

GST1_IMX_VERSION = 0.11.1
GST1_IMX_SITE = $(call github,Freescale,gstreamer-imx,$(GST1_IMX_VERSION))

GST1_IMX_LICENSE = LGPLv2+
GST1_IMX_LICENSE_FILES = LICENSE

GST1_IMX_INSTALL_STAGING = YES

GST1_IMX_DEPENDENCIES += host-pkgconf host-python \
	imx-gpu-viv gstreamer1 gst1-plugins-base libfslvpuwrap

# needs access to imx-specific kernel headers
GST1_IMX_DEPENDENCIES += linux
GST1_IMX_CONF_OPTS += --prefix="/usr" \
	--kernel-headers="$(LINUX_DIR)/include"

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

define GST1_IMX_CONFIGURE_CMDS
	cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		$(HOST_DIR)/usr/bin/python2 ./waf configure $(GST1_IMX_CONF_OPTS)
endef

define GST1_IMX_BUILD_CMDS
	cd $(@D); \
		$(HOST_DIR)/usr/bin/python2 ./waf build -j $(PARALLEL_JOBS)
endef

define GST1_IMX_INSTALL_TARGET_CMDS
	cd $(@D); \
		$(HOST_DIR)/usr/bin/python2 ./waf --destdir=$(TARGET_DIR) \
		install
endef

$(eval $(generic-package))
