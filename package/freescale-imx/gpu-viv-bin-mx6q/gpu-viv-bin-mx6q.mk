################################################################################
#
# gpu-viv-bin-mx6q
#
################################################################################

GPU_VIV_BIN_MX6Q_BASE_VERSION = 3.10.17-1.0.1
ifeq ($(BR2_ARM_EABIHF),y)
GPU_VIV_BIN_MX6Q_VERSION = $(GPU_VIV_BIN_MX6Q_BASE_VERSION)-hfp
else
GPU_VIV_BIN_MX6Q_VERSION = $(GPU_VIV_BIN_MX6Q_BASE_VERSION)-sfp
endif
GPU_VIV_BIN_MX6Q_SITE = $(FREESCALE_IMX_SITE)
GPU_VIV_BIN_MX6Q_SOURCE = gpu-viv-bin-mx6q-$(GPU_VIV_BIN_MX6Q_VERSION).bin

GPU_VIV_BIN_MX6Q_INSTALL_STAGING = YES

GPU_VIV_BIN_MX6Q_LICENSE = Freescale Semiconductor Software License Agreement
GPU_VIV_BIN_MX6Q_LICENSE_FILES = EULA
GPU_VIV_BIN_MX6Q_REDISTRIBUTE = NO

GPU_VIV_BIN_MX6Q_PROVIDES = libegl libgles libopenvg
GPU_VIV_BIN_MX6Q_LIB_TARGET = $(call qstrip,$(BR2_PACKAGE_GPU_VIV_BIN_MX6Q_OUTPUT))

define GPU_VIV_BIN_MX6Q_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(DL_DIR)/$(GPU_VIV_BIN_MX6Q_SOURCE))
endef

# Instead of building, we fix up the inconsistencies that exist
# in the upstream archive here.
# Make sure these commands are idempotent.
define GPU_VIV_BIN_MX6Q_BUILD_CMDS
	$(SED) 's/defined(LINUX)/defined(__linux__)/g' $(@D)/usr/include/*/*.h
	ln -sf libGL.so.1.2 $(@D)/usr/lib/libGL.so
	ln -sf libGL.so.1.2 $(@D)/usr/lib/libGL.so.1
	ln -sf libGL.so.1.2 $(@D)/usr/lib/libGL.so.1.2.0
	ln -sf libEGL-$(GPU_VIV_BIN_MX6Q_LIB_TARGET).so $(@D)/usr/lib/libEGL.so
	ln -sf libEGL-$(GPU_VIV_BIN_MX6Q_LIB_TARGET).so $(@D)/usr/lib/libEGL.so.1
	ln -sf libEGL-$(GPU_VIV_BIN_MX6Q_LIB_TARGET).so $(@D)/usr/lib/libEGL.so.1.0
	ln -sf libGLESv2-$(GPU_VIV_BIN_MX6Q_LIB_TARGET).so $(@D)/usr/lib/libGLESv2.so
	ln -sf libGLESv2-$(GPU_VIV_BIN_MX6Q_LIB_TARGET).so $(@D)/usr/lib/libGLESv2.so.2
	ln -sf libGLESv2-$(GPU_VIV_BIN_MX6Q_LIB_TARGET).so $(@D)/usr/lib/libGLESv2.so.2.0.0
	ln -sf libVIVANTE-$(GPU_VIV_BIN_MX6Q_LIB_TARGET).so $(@D)/usr/lib/libVIVANTE.so
	ln -sf libGAL-$(GPU_VIV_BIN_MX6Q_LIB_TARGET).so $(@D)/usr/lib/libGAL.so
endef

ifeq ($(GPU_VIV_BIN_MX6Q_LIB_TARGET),fb)
define GPU_VIV_BIN_MX6Q_FIXUP_FB_HEADERS
	$(SED) '/#define EGLAPIENTRY/ a \
		#if !defined(EGL_API_X11) && !defined(EGL_API_DFB) && !defined(EGL_API_FB) \n\
		#define EGL_API_FB \n\
		#endif' $(STAGING_DIR)/usr/include/EGL/eglvivante.h
endef
endif

define GPU_VIV_BIN_MX6Q_INSTALL_STAGING_CMDS
	cp -r $(@D)/usr/* $(STAGING_DIR)/usr
	$(GPU_VIV_BIN_MX6Q_FIXUP_FB_HEADERS)
	for lib in egl glesv2 vg; do \
		$(INSTALL) -m 0644 -D \
			package/freescale-imx/gpu-viv-bin-mx6q/$${lib}.pc \
			$(STAGING_DIR)/usr/lib/pkgconfig/$${lib}.pc; \
	done
endef

ifeq ($(BR2_PACKAGE_GPU_VIV_BIN_MX6Q_EXAMPLES),y)
define GPU_VIV_BIN_MX6Q_INSTALL_EXAMPLES
	mkdir -p $(TARGET_DIR)/usr/share/examples/
	cp -r $(@D)/opt/* $(TARGET_DIR)/usr/share/examples/
endef
endif

# On the target, remove the unused libraries.
# Note that this is _required_, else ldconfig may create symlinks
# to the wrong library
define GPU_VIV_BIN_MX6Q_INSTALL_TARGET_CMDS
	$(GPU_VIV_BIN_MX6Q_INSTALL_EXAMPLES)
	cp -a $(@D)/usr/lib $(TARGET_DIR)/usr
	for lib in EGL GAL VIVANTE GLESv2; do \
		for f in $(TARGET_DIR)/usr/lib/lib$${lib}-*.so; do \
			case $$f in \
				*-$(GPU_VIV_BIN_MX6Q_LIB_TARGET).so) : ;; \
				*) $(RM) $$f ;; \
			esac; \
		done; \
	done
endef

$(eval $(generic-package))
