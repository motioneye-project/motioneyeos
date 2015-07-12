################################################################################
#
# nvidia-tegra23-binaries
#
################################################################################

NVIDIA_TEGRA23_BINARIES_VERSION = $(NVIDIA_TEGRA23_VERSION)
NVIDIA_TEGRA23_BINARIES_SITE = $(NVIDIA_TEGRA23_SITE)
NVIDIA_TEGRA23_BINARIES_SOURCE = $(NVIDIA_TEGRA23_BASE)_R$(NVIDIA_TEGRA23_BINARIES_VERSION)_armhf.tbz2

NVIDIA_TEGRA23_BINARIES_LICENSE = License For Customer Use of NVIDIA Software
NVIDIA_TEGRA23_BINARIES_LICENSE_FILES = nv_tegra/LICENSE
ifeq ($(BR2_PACKAGE_NVIDIA_TEGRA23_BINARIES_GSTREAMER_PLUGINS),y)
NVIDIA_TEGRA23_BINARIES_LICENSE += LGPLv2.1
NVIDIA_TEGRA23_BINARIES_LICENSE_FILES += nv_tegra/nv_sample_apps/LICENSE.gst-openmax
endif

NVIDIA_TEGRA23_BINARIES_INSTALL_STAGING = YES

# Those are not really needed to build nvidia-tegra23-binaries, but
# will be needed by packages who link against libraries provided by
# nvidia-tegra23-binaries.

NVIDIA_TEGRA23_BINARIES_DEPENDENCIES = mesa3d-headers \
	xlib_libX11 xlib_libXext

ifeq ($(BR2_PACKAGE_NVIDIA_TEGRA23_BINARIES_GSTREAMER_PLUGINS),y)
NVIDIA_TEGRA23_BINARIES_DEPENDENCIES += xlib_libXv
endif

NVIDIA_TEGRA23_BINARIES_PROVIDES = libegl libgles libopenmax

NVIDIA_TEGRA23_BINARIES_DRV = \
	nv_tegra/nvidia_drivers/usr/lib/xorg/modules/drivers/tegra_drv.abi$(BR2_PACKAGE_XSERVER_XORG_SERVER_VIDEODRV_ABI).so

define NVIDIA_TEGRA23_BINARIES_EXTRACT_FURTHER
	$(INSTALL) -d $(@D)/nv_tegra/nvidia_drivers
	$(call suitable-extractor,$(@D)/nv_tegra/nvidia_drivers.tbz2) \
		$(@D)/nv_tegra/nvidia_drivers.tbz2 | \
	$(TAR) --strip-components=0 -C $(@D)/nv_tegra/nvidia_drivers/ $(TAR_OPTIONS) -
	$(INSTALL) -d $(@D)/nv_tegra/nv_sample_apps/nvgstapps
	$(call suitable-extractor,$(@D)/nv_tegra/nv_sample_apps/nvgstapps.tbz2) \
		$(@D)/nv_tegra/nv_sample_apps/nvgstapps.tbz2 | \
	$(TAR) --strip-components=0 -C $(@D)/nv_tegra/nv_sample_apps/nvgstapps/ $(TAR_OPTIONS) -
endef
NVIDIA_TEGRA23_BINARIES_POST_EXTRACT_HOOKS += NVIDIA_TEGRA23_BINARIES_EXTRACT_FURTHER

define NVIDIA_TEGRA23_BINARIES_INSTALL_LIBS
	mkdir -p $(1)/usr/lib
	cp -dpfr $(@D)/nv_tegra/nvidia_drivers/usr/lib/*.so $(1)/usr/lib/
	(cd $(1)/usr/lib; \
		ln -sf libGLESv2.so.2 libGLESv2.so; \
		ln -sf libGLESv1_CM.so.1 libGLESv1_CM.so; \
		ln -sf libEGL.so.1 libEGL.so \
	)
endef

ifeq ($(BR2_PACKAGE_NVIDIA_TEGRA23_BINARIES_GSTREAMER_PLUGINS),y)
define NVIDIA_TEGRA23_BINARIES_INSTALL_GST_PLUGINS
	mkdir -p $(1)/usr/lib/gstreamer-0.10/
	cp -dpfr $(@D)/nv_tegra/nv_sample_apps/nvgstapps/usr/lib/gstreamer-0.10/*.so \
		$(1)/usr/lib/gstreamer-0.10/
endef
endif

ifeq ($(BR2_PACKAGE_NVIDIA_TEGRA23_BINARIES_NV_SAMPLE_APPS),y)
define NVIDIA_TEGRA23_BINARIES_INSTALL_APPS
	mkdir -p $(TARGET_DIR)/usr/bin/
	cp -dpfr $(@D)/nv_tegra/nv_sample_apps/nvgstapps/usr/bin/* \
		$(TARGET_DIR)/usr/bin/
endef
endif

define NVIDIA_TEGRA23_BINARIES_INSTALL_STAGING_CMDS
	$(call NVIDIA_TEGRA23_BINARIES_INSTALL_LIBS,$(STAGING_DIR))
	mkdir -p $(STAGING_DIR)/usr/lib/pkgconfig/
	cp -dpfr package/nvidia-tegra23/nvidia-tegra23-binaries/*.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/
	$(call NVIDIA_TEGRA23_BINARIES_INSTALL_GST_PLUGINS,$(STAGING_DIR))
endef

define NVIDIA_TEGRA23_BINARIES_INSTALL_TARGET_CMDS
	$(call NVIDIA_TEGRA23_BINARIES_INSTALL_LIBS,$(TARGET_DIR))
	mkdir -p $(TARGET_DIR)/lib/firmware/
	cp -dpfr $(@D)/nv_tegra/nvidia_drivers/lib/firmware/*.bin \
		$(TARGET_DIR)/lib/firmware/
	$(INSTALL) -D -m 0644 $(@D)/nv_tegra/nvidia_drivers/etc/nv_tegra_release \
		$(TARGET_DIR)/etc/nv_tegra_release
	$(INSTALL) -D -m 0644 $(@D)/$(NVIDIA_TEGRA23_BINARIES_DRV) \
		$(TARGET_DIR)/usr/lib/xorg/modules/drivers/tegra_drv.so
	$(call NVIDIA_TEGRA23_BINARIES_INSTALL_GST_PLUGINS,$(TARGET_DIR))
	$(NVIDIA_TEGRA23_BINARIES_INSTALL_APPS)
endef

$(eval $(generic-package))
