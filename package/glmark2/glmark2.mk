################################################################################
#
# glmark2
#
################################################################################

GLMARK2_VERSION = 9e01aef1a786b28aca73135a5b00f85c357e8f5e
GLMARK2_SITE = $(call github,glmark2,glmark2,$(GLMARK2_VERSION))
GLMARK2_LICENSE = GPL-3.0+, SGIv1
GLMARK2_LICENSE_FILES = COPYING COPYING.SGI
GLMARK2_DEPENDENCIES = host-pkgconf jpeg libegl libpng

ifeq ($(BR2_PACKAGE_GLMARK2_FLAVOR_DRM_GLESV2),y)
GLMARK2_DEPENDENCIES += libgles udev
GLMARK2_FLAVORS += drm-glesv2
endif

ifeq ($(BR2_PACKAGE_GLMARK2_FLAVOR_DRM_GL),y)
GLMARK2_DEPENDENCIES += libgl udev
GLMARK2_FLAVORS += drm-gl
endif

ifeq ($(BR2_PACKAGE_GLMARK2_FLAVOR_X11_GLESV2),y)
GLMARK2_DEPENDENCIES += libgles xlib_libX11
GLMARK2_FLAVORS += x11-glesv2
endif

ifeq ($(BR2_PACKAGE_GLMARK2_FLAVOR_X11_GL),y)
GLMARK2_DEPENDENCIES += libgl xlib_libX11
GLMARK2_FLAVORS += x11-gl
endif

ifeq ($(BR2_PACKAGE_GLMARK2_FLAVOR_WAYLAND_GLESV2),y)
GLMARK2_DEPENDENCIES += libgles wayland
GLMARK2_FLAVORS += wayland-glesv2
endif

ifeq ($(BR2_PACKAGE_GLMARK2_FLAVOR_WAYLAND_GL),y)
GLMARK2_DEPENDENCIES += libgl wayland
GLMARK2_FLAVORS += wayland-gl
endif

GLMARK2_CONF_OPTS += \
	--prefix=/usr \
	--with-flavors=$(subst $(space),$(comma),$(GLMARK2_FLAVORS))

$(eval $(waf-package))
