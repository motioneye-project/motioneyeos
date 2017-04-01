################################################################################
#
# mesa3d
#
################################################################################

# When updating the version, please also update mesa3d-headers
MESA3D_VERSION = 17.0.3
MESA3D_SOURCE = mesa-$(MESA3D_VERSION).tar.xz
MESA3D_SITE = https://mesa.freedesktop.org/archive
MESA3D_LICENSE = MIT, SGI, Khronos
MESA3D_LICENSE_FILES = docs/license.html
MESA3D_AUTORECONF = YES

MESA3D_INSTALL_STAGING = YES

MESA3D_PROVIDES =

MESA3D_DEPENDENCIES = \
	host-bison \
	host-flex \
	expat \
	libdrm

# Disable assembly usage.
MESA3D_CONF_OPTS = --disable-asm

# The Sourcery MIPS toolchain has a special (non-upstream) feature to
# have "compact exception handling", which unfortunately breaks with
# mesa3d, so we disable it here by passing -mno-compact-eh.
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CODESOURCERY_MIPS),y)
MESA3D_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -mno-compact-eh"
MESA3D_CONF_ENV += CXXFLAGS="$(TARGET_CXXFLAGS) -mno-compact-eh"
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
MESA3D_DEPENDENCIES += \
	xproto_xf86driproto \
	xproto_dri2proto \
	xproto_glproto \
	xlib_libX11 \
	xlib_libXext \
	xlib_libXdamage \
	xlib_libXfixes \
	libxcb
MESA3D_CONF_OPTS += --enable-glx --disable-mangling
# quote from mesa3d configure "Building xa requires at least one non swrast gallium driver."
ifeq ($(BR2_PACKAGE_MESA3D_NEEDS_XA),y)
MESA3D_CONF_OPTS += --enable-xa
else
MESA3D_CONF_OPTS += --disable-xa
endif
else
MESA3D_CONF_OPTS += \
	--disable-glx \
	--disable-xa
endif

# Drivers

#Gallium Drivers
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_ETNAVIV)  += etnaviv imx
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_NOUVEAU)  += nouveau
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_R600)     += r600
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_SVGA)     += svga
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_SWRAST)   += swrast
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_VC4)      += vc4
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_VIRGL)    += virgl
# DRI Drivers
MESA3D_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_DRI_DRIVER_SWRAST) += swrast
MESA3D_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_DRI_DRIVER_I915)   += i915
MESA3D_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_DRI_DRIVER_I965)   += i965
MESA3D_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_DRI_DRIVER_NOUVEAU) += nouveau
MESA3D_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_DRI_DRIVER_RADEON) += radeon
# Vulkan Drivers
MESA3D_VULKAN_DRIVERS-$(BR2_PACKAGE_MESA3D_VULKAN_DRIVER_INTEL)   += intel

ifeq ($(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER),)
MESA3D_CONF_OPTS += \
	--without-gallium-drivers \
	--disable-gallium-extra-hud
else
MESA3D_CONF_OPTS += \
	--enable-shared-glapi \
	--with-gallium-drivers=$(subst $(space),$(comma),$(MESA3D_GALLIUM_DRIVERS-y)) \
	--enable-gallium-extra-hud
endif

ifeq ($(BR2_PACKAGE_MESA3D_DRI_DRIVER),)
MESA3D_CONF_OPTS += \
	--without-dri-drivers --disable-dri3
else
ifeq ($(BR2_PACKAGE_XPROTO_DRI3PROTO),y)
MESA3D_DEPENDENCIES += xlib_libxshmfence xproto_dri3proto xproto_presentproto
MESA3D_CONF_OPTS += --enable-dri3
else
MESA3D_CONF_OPTS += --disable-dri3
endif
ifeq ($(BR2_PACKAGE_XLIB_LIBXXF86VM),y)
MESA3D_DEPENDENCIES += xlib_libXxf86vm
endif
MESA3D_CONF_OPTS += \
	--enable-shared-glapi \
	--enable-driglx-direct \
	--with-dri-drivers=$(subst $(space),$(comma),$(MESA3D_DRI_DRIVERS-y))
endif

ifeq ($(BR2_PACKAGE_MESA3D_VULKAN_DRIVER),)
MESA3D_CONF_OPTS += \
	--without-vulkan-drivers
else
MESA3D_CONF_OPTS += \
	--with-vulkan-drivers=$(subst $(space),$(comma),$(MESA3D_VULKAN_DRIVERS-y))
endif

# APIs

ifeq ($(BR2_PACKAGE_MESA3D_OSMESA),y)
MESA3D_CONF_OPTS += --enable-osmesa
else
MESA3D_CONF_OPTS += --disable-osmesa
endif

# Always enable OpenGL:
#   - it is needed for GLES (mesa3d's ./configure is a bit weird)
MESA3D_CONF_OPTS += --enable-opengl --enable-dri

# libva and mesa3d have a circular dependency
# we do not need libva support in mesa3d, therefore disable this option
MESA3D_CONF_OPTS += --disable-va

# libGL is only provided for a full xorg stack
ifeq ($(BR2_PACKAGE_XORG7),y)
MESA3D_PROVIDES += libgl
else
define MESA3D_REMOVE_OPENGL_HEADERS
	rm -rf $(STAGING_DIR)/usr/include/GL/
endef

MESA3D_POST_INSTALL_STAGING_HOOKS += MESA3D_REMOVE_OPENGL_HEADERS
endif

ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_EGL),y)
MESA3D_PROVIDES += libegl
ifeq ($(BR2_PACKAGE_MESA3D_DRI_DRIVER),y)
MESA3D_EGL_PLATFORMS = drm
else ifeq ($(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_VC4),y)
MESA3D_EGL_PLATFORMS = drm
else ifeq ($(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_ETNAVIV),y)
MESA3D_EGL_PLATFORMS = drm
else ifeq ($(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_VIRGL),y)
MESA3D_EGL_PLATFORMS = drm
endif
ifeq ($(BR2_PACKAGE_WAYLAND),y)
MESA3D_DEPENDENCIES += wayland
MESA3D_EGL_PLATFORMS += wayland
endif
ifeq ($(BR2_PACKAGE_XORG7),y)
MESA3D_EGL_PLATFORMS += x11
endif
MESA3D_CONF_OPTS += \
	--enable-gbm \
	--enable-egl \
	--with-egl-platforms=$(subst $(space),$(comma),$(MESA3D_EGL_PLATFORMS))
else
MESA3D_CONF_OPTS += \
	--disable-egl
endif

ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_ES),y)
MESA3D_PROVIDES += libgles
MESA3D_CONF_OPTS += --enable-gles1 --enable-gles2
else
MESA3D_CONF_OPTS += --disable-gles1 --disable-gles2
endif

ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_TEXTURE_FLOAT),y)
MESA3D_CONF_OPTS += --enable-texture-float
MESA3D_LICENSE_FILES += docs/patents.txt
else
MESA3D_CONF_OPTS += --disable-texture-float
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXVMC),y)
MESA3D_DEPENDENCIES += xlib_libXvMC
MESA3D_CONF_OPTS += --enable-xvmc
else
MESA3D_CONF_OPTS += --disable-xvmc
endif

ifeq ($(BR2_PACKAGE_LIBVDPAU),y)
MESA3D_DEPENDENCIES += libvdpau
MESA3D_CONF_OPTS += --enable-vdpau
else
MESA3D_CONF_OPTS += --disable-vdpau
endif

ifeq ($(BR2_PACKAGE_LM_SENSORS),y)
MESA3D_CONF_OPTS += --enable-lmsensors
MESA3D_DEPENDENCIES += lm-sensors
else
MESA3D_CONF_OPTS += --disable-lmsensors
endif

# Avoid automatic search of llvm-config
MESA3D_CONF_OPTS += --with-llvm-prefix=$(STAGING_DIR)/usr/bin

$(eval $(autotools-package))
