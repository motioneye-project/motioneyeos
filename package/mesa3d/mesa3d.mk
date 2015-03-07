################################################################################
#
# mesa3d
#
################################################################################

# When updating the version, please also update mesa3d-headers
MESA3D_VERSION = 10.4.6
MESA3D_SOURCE = MesaLib-$(MESA3D_VERSION).tar.bz2
MESA3D_SITE = ftp://ftp.freedesktop.org/pub/mesa/$(MESA3D_VERSION)
MESA3D_LICENSE = MIT, SGI, Khronos
MESA3D_LICENSE_FILES = docs/license.html
MESA3D_AUTORECONF = YES

MESA3D_INSTALL_STAGING = YES

MESA3D_PROVIDES =

MESA3D_DEPENDENCIES = \
	expat \
	host-bison \
	host-flex \
	host-gettext \
	host-python \
	host-xutil_makedepend \
	libdrm

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
MESA3D_CONF_OPTS += --enable-glx
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

ifeq ($(BR2_STATIC_LIBS),)
# fix for "configure: error: Cannot use static libraries for DRI drivers"
MESA3D_CONF_OPTS += --disable-static
endif

# Drivers

#Gallium Drivers
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_NOUVEAU)  += nouveau
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_R600)     += r600
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_SVGA)     += svga
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_SWRAST)   += swrast
# DRI Drivers
MESA3D_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_DRI_DRIVER_SWRAST) += swrast
MESA3D_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_DRI_DRIVER_I915)   += i915
MESA3D_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_DRI_DRIVER_I965)   += i965
MESA3D_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_DRI_DRIVER_RADEON) += radeon

ifeq ($(MESA3D_GALLIUM_DRIVERS-y),)
MESA3D_CONF_OPTS += \
	--without-gallium-drivers
else
MESA3D_CONF_OPTS += \
	--enable-shared-glapi \
	--with-gallium-drivers=$(subst $(space),$(comma),$(MESA3D_GALLIUM_DRIVERS-y))
endif

ifeq ($(MESA3D_DRI_DRIVERS-y),)
MESA3D_CONF_OPTS += \
	--without-dri-drivers --without-dri --disable-dri3
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
MESA3D_PROVIDES += libgl
MESA3D_CONF_OPTS += \
	--enable-dri \
	--enable-shared-glapi \
	--with-dri-drivers=$(subst $(space),$(comma),$(MESA3D_DRI_DRIVERS-y))
endif

# APIs

# Always enable OpenGL:
#   - it is needed for GLES (mesa3d's ./configure is a bit weird)
#   - but if no DRI driver is enabled, then libgl is not built
MESA3D_CONF_OPTS += --enable-opengl

ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_EGL),y)
MESA3D_PROVIDES += libegl
# egl depends on gbm, gbm depends on udev
MESA3D_DEPENDENCIES += udev
MESA3D_EGL_PLATFORMS = drm
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

$(eval $(autotools-package))
