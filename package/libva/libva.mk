################################################################################
#
# libva
#
################################################################################

LIBVA_VERSION = 2.0.0
LIBVA_SOURCE = libva-$(LIBVA_VERSION).tar.bz2
LIBVA_SITE = https://github.com/01org/libva/releases/download/$(LIBVA_VERSION)
LIBVA_LICENSE = MIT
LIBVA_LICENSE_FILES = COPYING
LIBVA_INSTALL_STAGING = YES
LIBVA_DEPENDENCIES = host-pkgconf libdrm

# libdrm is a hard-dependency
LIBVA_CONF_OPTS = \
	--enable-drm \
	--with-drivers-path="/usr/lib/va"

ifeq ($(BR2_PACKAGE_XORG7),y)
LIBVA_DEPENDENCIES += xlib_libX11 xlib_libXext xlib_libXfixes
LIBVA_CONF_OPTS += --enable-x11
ifeq ($(BR2_PACKAGE_MESA3D_DRI_DRIVER),y)
LIBVA_DEPENDENCIES += mesa3d
LIBVA_CONF_OPTS += --enable-glx
endif
else
LIBVA_CONF_OPTS += --disable-glx --disable-x11
endif

ifeq ($(BR2_PACKAGE_WAYLAND),y)
LIBVA_DEPENDENCIES += wayland
LIBVA_CONF_OPTS += --enable-wayland
else
LIBVA_CONF_OPTS += --disable-wayland
endif

$(eval $(autotools-package))
