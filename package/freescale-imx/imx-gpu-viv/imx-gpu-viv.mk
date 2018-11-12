################################################################################
#
# imx-gpu-viv
#
################################################################################

ifeq ($(BR2_aarch64),y)
IMX_GPU_VIV_VERSION = 6.2.4.p1.2-aarch64
else
IMX_GPU_VIV_VERSION = 6.2.4.p1.2-aarch32
endif
IMX_GPU_VIV_SITE = $(FREESCALE_IMX_SITE)
IMX_GPU_VIV_SOURCE = imx-gpu-viv-$(IMX_GPU_VIV_VERSION).bin

IMX_GPU_VIV_INSTALL_STAGING = YES

IMX_GPU_VIV_LICENSE = NXP Semiconductor Software License Agreement
IMX_GPU_VIV_LICENSE_FILES = EULA COPYING
IMX_GPU_VIV_REDISTRIBUTE = NO

IMX_GPU_VIV_PROVIDES = libegl libgles libopenvg
IMX_GPU_VIV_LIB_TARGET = $(call qstrip,$(BR2_PACKAGE_IMX_GPU_VIV_OUTPUT))

ifeq ($(IMX_GPU_VIV_LIB_TARGET),x11)
# The libGAL.so library provided by imx-gpu-viv uses X functions. Packages
# may want to link against libGAL.so (QT5 Base with OpenGL and X support
# does so). For this to work we need build dependencies to libXdamage,
# libXext and libXfixes so that X functions used in libGAL.so are referenced.
IMX_GPU_VIV_DEPENDENCIES += xlib_libXdamage xlib_libXext xlib_libXfixes
endif

ifeq ($(IMX_GPU_VIV_LIB_TARGET),wl)
IMX_GPU_VIV_DEPENDENCIES += libdrm wayland
endif

define IMX_GPU_VIV_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(IMX_GPU_VIV_DL_DIR)/$(IMX_GPU_VIV_SOURCE))
endef

# Instead of building, we fix up the inconsistencies that exist
# in the upstream archive here.
# Make sure these commands are idempotent.
define IMX_GPU_VIV_BUILD_CMDS
	$(SED) 's/defined(LINUX)/defined(__linux__)/g' $(@D)/gpu-core/usr/include/*/*.h
	ln -sf libGL.so.1.2 $(@D)/gpu-core/usr/lib/libGL.so
	ln -sf libGL.so.1.2 $(@D)/gpu-core/usr/lib/libGL.so.1
	ln -sf libGL.so.1.2 $(@D)/gpu-core/usr/lib/libGL.so.1.2.0
	ln -sf libEGL-$(IMX_GPU_VIV_LIB_TARGET).so $(@D)/gpu-core/usr/lib/libEGL.so
	ln -sf libEGL-$(IMX_GPU_VIV_LIB_TARGET).so $(@D)/gpu-core/usr/lib/libEGL.so.1
	ln -sf libEGL-$(IMX_GPU_VIV_LIB_TARGET).so $(@D)/gpu-core/usr/lib/libEGL.so.1.0
	ln -sf libGLESv2-$(IMX_GPU_VIV_LIB_TARGET).so $(@D)/gpu-core/usr/lib/libGLESv2.so
	ln -sf libGLESv2-$(IMX_GPU_VIV_LIB_TARGET).so $(@D)/gpu-core/usr/lib/libGLESv2.so.2
	ln -sf libGLESv2-$(IMX_GPU_VIV_LIB_TARGET).so $(@D)/gpu-core/usr/lib/libGLESv2.so.2.0.0
	ln -sf libGAL-$(IMX_GPU_VIV_LIB_TARGET).so $(@D)/gpu-core/usr/lib/libGAL.so
	ln -sf libVDK-$(IMX_GPU_VIV_LIB_TARGET).so $(@D)/gpu-core/usr/lib/libVDK.so
endef

ifeq ($(IMX_GPU_VIV_LIB_TARGET),fb)
define IMX_GPU_VIV_FIXUP_FB_HEADERS
	$(SED) '39i\
		#if !defined(EGL_API_X11) && !defined(EGL_API_DFB) && !defined(EGL_API_FB) \n\
		#define EGL_API_FB \n\
		#endif' $(STAGING_DIR)/usr/include/EGL/eglplatform.h
endef
endif

ifeq ($(IMX_GPU_VIV_LIB_TARGET),fb)
define IMX_GPU_VIV_FIXUP_PKGCONFIG
	ln -sf egl_linuxfb.pc $(@D)/gpu-core/usr/lib/pkgconfig/egl.pc
endef
endif

ifeq ($(IMX_GPU_VIV_LIB_TARGET),wl)
define IMX_GPU_VIV_FIXUP_PKGCONFIG
	ln -sf egl_wayland.pc $(@D)/gpu-core/usr/lib/pkgconfig/egl.pc
endef
endif

ifeq ($(IMX_GPU_VIV_LIB_TARGET),x11)
define IMX_GPU_VIV_FIXUP_PKGCONFIG
	for lib in egl gbm glesv1_cm glesv2 vg; do \
		ln -sf $${lib}_x11.pc $(@D)/gpu-core/usr/lib/pkgconfig/$${lib}.pc || exit 1; \
	done
endef
endif

define IMX_GPU_VIV_INSTALL_STAGING_CMDS
	cp -r $(@D)/gpu-core/usr/* $(STAGING_DIR)/usr
	$(IMX_GPU_VIV_FIXUP_FB_HEADERS)
	$(IMX_GPU_VIV_FIXUP_PKGCONFIG)
	for lib in egl gbm glesv1_cm glesv2 vg; do \
		$(INSTALL) -m 0644 -D \
			$(@D)/gpu-core/usr/lib/pkgconfig/$${lib}.pc \
			$(STAGING_DIR)/usr/lib/pkgconfig/$${lib}.pc; \
	done
endef

ifeq ($(BR2_PACKAGE_IMX_GPU_VIV_EXAMPLES),y)
define IMX_GPU_VIV_INSTALL_EXAMPLES
	mkdir -p $(TARGET_DIR)/usr/share/examples/
	cp -r $(@D)/gpu-demos/opt/* $(TARGET_DIR)/usr/share/examples/
endef
endif

ifeq ($(BR2_PACKAGE_IMX_GPU_VIV_GMEM_INFO),y)
define IMX_GPU_VIV_INSTALL_GMEM_INFO
	cp -dpfr $(@D)/gpu-tools/gmem-info/usr/bin/* $(TARGET_DIR)/usr/bin/
endef
endif

# On the target, remove the unused libraries.
# Note that this is _required_, else ldconfig may create symlinks
# to the wrong library
define IMX_GPU_VIV_INSTALL_TARGET_CMDS
	$(IMX_GPU_VIV_INSTALL_EXAMPLES)
	$(IMX_GPU_VIV_INSTALL_GMEM_INFO)
	cp -a $(@D)/gpu-core/usr/lib $(TARGET_DIR)/usr
	for lib in EGL GAL GLESv2 VDK; do \
		for f in $(TARGET_DIR)/usr/lib/lib$${lib}-*.so; do \
			case $$f in \
				*-$(IMX_GPU_VIV_LIB_TARGET).so) : ;; \
				*) $(RM) $$f ;; \
			esac; \
		done; \
	done
endef

$(eval $(generic-package))
