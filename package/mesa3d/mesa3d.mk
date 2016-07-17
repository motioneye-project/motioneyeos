################################################################################
#
# mesa3d
#
################################################################################

# When updating the version, please also update mesa3d-headers
MESA3D_VERSION = 12.0.1
MESA3D_SOURCE = mesa-$(MESA3D_VERSION).tar.xz
MESA3D_SITE = ftp://ftp.freedesktop.org/pub/mesa/$(MESA3D_VERSION)
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

# The Sourcery MIPS toolchain has a special (non-upstream) feature to
# have "compact exception handling", which unfortunately breaks with
# mesa3d, so we disable it here by passing -mno-compact-eh.
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CODESOURCERY_MIPS),y)
MESA3D_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -mno-compact-eh"
MESA3D_CONF_ENV += CXXFLAGS="$(TARGET_CXXFLAGS) -mno-compact-eh"
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
MESA3D_DEPENDENCIES += openssl
MESA3D_CONF_OPTS += --with-sha1=libcrypto
else ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
MESA3D_DEPENDENCIES += libgcrypt
MESA3D_CONF_OPTS += --with-sha1=libgcrypt
else ifeq ($(BR2_PACKAGE_LIBSHA1),y)
MESA3D_DEPENDENCIES += libsha1
MESA3D_CONF_OPTS += --with-sha1=libsha1
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
MESA3D_DEPENDENCIES += udev
MESA3D_CONF_OPTS += --disable-sysfs
else
MESA3D_CONF_OPTS += --enable-sysfs
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

ifeq ($(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER),)
MESA3D_CONF_OPTS += \
	--without-gallium-drivers
else
MESA3D_CONF_OPTS += \
	--enable-shared-glapi \
	--with-gallium-drivers=$(subst $(space),$(comma),$(MESA3D_GALLIUM_DRIVERS-y))
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
# libGL is only provided for a full xorg stack
ifeq ($(BR2_PACKAGE_XORG7),y)
MESA3D_PROVIDES += libgl
endif
MESA3D_CONF_OPTS += \
	--enable-shared-glapi \
	--enable-driglx-direct \
	--with-dri-drivers=$(subst $(space),$(comma),$(MESA3D_DRI_DRIVERS-y))
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

ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_EGL),y)
MESA3D_PROVIDES += libegl
ifeq ($(BR2_PACKAGE_MESA3D_DRI_DRIVER),y)
MESA3D_EGL_PLATFORMS = drm
else ifeq ($(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_VC4),y)
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

# Avoid automatic search of llvm-config
MESA3D_CONF_OPTS += --with-llvm-prefix=$(STAGING_DIR)/usr/bin

$(eval $(autotools-package))
