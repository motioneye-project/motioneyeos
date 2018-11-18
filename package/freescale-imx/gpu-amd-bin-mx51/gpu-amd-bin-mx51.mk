################################################################################
#
# gpu-amd-bin-mx51
#
################################################################################

GPU_AMD_BIN_MX51_SITE = $(FREESCALE_IMX_SITE)
GPU_AMD_BIN_MX51_BASE_VERSION = 11.09.01
ifeq ($(BR2_PACKAGE_GPU_AMD_BIN_MX51_OUTPUT_FB),y)
GPU_AMD_BIN_MX51_VERSION = $(GPU_AMD_BIN_MX51_BASE_VERSION)-fb
GPU_AMD_BIN_MX51_SOURCE = amd-gpu-bin-mx51-$(GPU_AMD_BIN_MX51_BASE_VERSION).bin
else
GPU_AMD_BIN_MX51_VERSION = $(GPU_AMD_BIN_MX51_BASE_VERSION)-x11
GPU_AMD_BIN_MX51_SOURCE = amd-gpu-x11-bin-mx51-$(GPU_AMD_BIN_MX51_BASE_VERSION).bin
GPU_AMD_BIN_MX51_DEPENDENCIES = libxcb xlib_libX11 xlib_libXext \
	xlib_libXrender xlib_libXau xlib_libXdmcp
endif
GPU_AMD_BIN_MX51_PROVIDES = libegl libgles libopenvg
GPU_AMD_BIN_MX51_INSTALL_STAGING = YES

GPU_AMD_BIN_MX51_LICENSE = Freescale Semiconductor Software License Agreement
GPU_AMD_BIN_MX51_LICENSE_FILES = EULA
GPU_AMD_BIN_MX51_REDISTRIBUTE = NO

define GPU_AMD_BIN_MX51_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(GPU_AMD_BIN_MX51_DL_DIR)/$(GPU_AMD_BIN_MX51_SOURCE))
endef

# Upstream headers need to be compiled with -D_LINUX. It is more convenient
# to rely on __linux__ which is defined in compiler itself
define GPU_AMD_BIN_MX51_FIXUP_HEADERS
	$(SED) 's/_LINUX/__linux__/g' $(@D)/usr/include/*/*.h
endef
GPU_AMD_BIN_MX51_POST_PATCH_HOOKS += GPU_AMD_BIN_MX51_FIXUP_HEADERS

# eglplatform_1.4.h contains X11 compatible headers
ifeq ($(BR2_PACKAGE_GPU_AMD_BIN_MX51_OUTPUT_X11),y)
define GPU_AMD_BIN_MX51_FIXUP_EGL_HEADERS
	mv $(STAGING_DIR)/usr/include/EGL/eglplatform_1.4.h $(STAGING_DIR)/usr/include/EGL/eglplatform.h
endef
endif

define GPU_AMD_BIN_MX51_INSTALL_STAGING_CMDS
	$(INSTALL) -d $(STAGING_DIR)/usr/lib/pkgconfig
	$(INSTALL) -m 644 package/freescale-imx/gpu-amd-bin-mx51/*.pc $(STAGING_DIR)/usr/lib/pkgconfig/
	$(INSTALL) -m 755 $(@D)/usr/lib/lib* $(STAGING_DIR)/usr/lib/
	cp -r $(@D)/usr/include/* $(STAGING_DIR)/usr/include
	$(GPU_AMD_BIN_MX51_FIXUP_EGL_HEADERS)
endef

ifeq ($(BR2_PACKAGE_GPU_AMD_BIN_MX51_EXAMPLES),y)
define GPU_AMD_BIN_MX51_INSTALL_EXAMPLES
	$(INSTALL) -d $(TARGET_DIR)/usr/share/examples/gpu_amd_samples
	$(INSTALL) -m 755 $(@D)/usr/bin/* $(TARGET_DIR)/usr/share/examples/gpu_amd_samples
endef
endif

define GPU_AMD_BIN_MX51_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/usr/lib/lib*so* $(TARGET_DIR)/usr/lib/
	$(GPU_AMD_BIN_MX51_INSTALL_EXAMPLES)
endef

define GPU_AMD_BIN_MX51_DEVICES
	/dev/gsl_kmod c 640 0 0 249 0 1 4
endef

$(eval $(generic-package))
