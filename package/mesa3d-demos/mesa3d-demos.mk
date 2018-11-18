################################################################################
#
# mesa3d-demos
#
################################################################################

MESA3D_DEMOS_VERSION = 8.4.0
MESA3D_DEMOS_SOURCE = mesa-demos-$(MESA3D_DEMOS_VERSION).tar.bz2
MESA3D_DEMOS_SITE = ftp://ftp.freedesktop.org/pub/mesa/demos
# 0001-demos-makes-opengl-an-optional-component.patch
MESA3D_DEMOS_AUTORECONF = YES
MESA3D_DEMOS_DEPENDENCIES = host-pkgconf
MESA3D_DEMOS_LICENSE = MIT

MESA3D_DEMOS_CONF_OPTS += \
	--disable-gles1

ifeq ($(BR2_PACKAGE_XORG7)$(BR2_PACKAGE_HAS_LIBGL),yy)
MESA3D_DEMOS_DEPENDENCIES += libgl libglew libglu xlib_libX11 xlib_libXext
MESA3D_DEMOS_CONF_OPTS += --enable-gl --enable-x11
else
MESA3D_DEMOS_CONF_OPTS += --disable-gl --disable-x11
endif

ifeq ($(BR2_PACKAGE_HAS_LIBEGL),y)
MESA3D_DEMOS_DEPENDENCIES += libegl
MESA3D_DEMOS_CONF_OPTS += --enable-egl
else
MESA3D_DEMOS_CONF_OPTS += --disable-egl
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
MESA3D_DEMOS_DEPENDENCIES += libgles
MESA3D_DEMOS_CONF_OPTS += --enable-gles2
else
MESA3D_DEMOS_CONF_OPTS += --disable-gles2
endif

ifeq ($(BR2_PACKAGE_HAS_LIBOPENVG),y)
MESA3D_DEMOS_DEPENDENCIES += libopenvg
MESA3D_DEMOS_CONF_OPTS += --enable-vg
else
MESA3D_DEMOS_CONF_OPTS += --disable-vg
endif

ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_EGL),y)
MESA3D_DEMOS_DEPENDENCIES += mesa3d
MESA3D_DEMOS_CONF_OPTS += --enable-gbm
else
MESA3D_DEMOS_CONF_OPTS += --disable-gbm
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
MESA3D_DEMOS_DEPENDENCIES += freetype
MESA3D_DEMOS_CONF_OPTS += --enable-freetype2
else
MESA3D_DEMOS_CONF_OPTS += --disable-freetype2
endif

ifeq ($(BR2_PACKAGE_LIBFREEGLUT),y)
MESA3D_DEMOS_DEPENDENCIES += libfreeglut
MESA3D_DEMOS_CONF_OPTS += --with-glut=$(STAGING_DIR)/usr
# osmesa support depends on glut
ifeq ($(BR2_PACKAGE_MESA3D_OSMESA),y)
MESA3D_DEMOS_CONF_OPTS += --enable-osmesa
else
MESA3D_DEMOS_CONF_OPTS += --disable-osmesa
endif
else
MESA3D_DEMOS_CONF_OPTS += --without-glut --disable-osmesa
endif

ifeq ($(BR2_PACKAGE_WAYLAND),y)
MESA3D_DEMOS_DEPENDENCIES += wayland
MESA3D_DEMOS_CONF_OPTS += --enable-wayland
else
MESA3D_DEMOS_CONF_OPTS += --disable-wayland
endif

$(eval $(autotools-package))
