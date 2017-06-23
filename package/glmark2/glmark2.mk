################################################################################
#
# glmark2
#
################################################################################

GLMARK2_VERSION = 9b1070fe9c5cf908f323909d3c8cbed08022abe8
GLMARK2_SITE = $(call github,glmark2,glmark2,$(GLMARK2_VERSION))
GLMARK2_LICENSE = GPL-3.0+, SGIv1
GLMARK2_LICENSE_FILES = COPYING COPYING.SGI
GLMARK2_DEPENDENCIES = host-pkgconf jpeg libpng \
	$(if $(BR2_PACKAGE_HAS_LIBEGL),libegl) \
	$(if $(BR2_PACKAGE_HAS_LIBGLES),libgles) \
	$(if $(BR2_PACKAGE_HAS_LIBGL),libgl)

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
GLMARK2_DEPENDENCIES += xlib_libX11
ifeq ($(BR2_PACKAGE_HAS_LIBEGL)$(BR2_PACKAGE_HAS_LIBGLES),yy)
GLMARK2_FLAVORS += x11-glesv2
endif
ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
GLMARK2_FLAVORS += x11-gl
endif
endif

ifeq ($(BR2_PACKAGE_HAS_LIBEGL)$(BR2_PACKAGE_HAS_LIBGLES),yy)
GLMARK2_FLAVORS += drm-glesv2
endif

ifeq ($(BR2_PACKAGE_HAS_LIBEGL)$(BR2_PACKAGE_HAS_LIBGL),yy)
GLMARK2_FLAVORS += drm-gl
endif

ifeq ($(BR2_PACKAGE_WAYLAND)$(BR2_PACKAGE_HAS_LIBEGL)$(BR2_PACKAGE_HAS_LIBGLES),yyy)
GLMARK2_DEPENDENCIES += wayland
GLMARK2_FLAVORS += wayland-glesv2
endif

ifeq ($(BR2_PACKAGE_WAYLAND)$(BR2_PACKAGE_HAS_LIBEGL)$(BR2_PACKAGE_HAS_LIBGL),yyy)
GLMARK2_DEPENDENCIES += wayland
GLMARK2_FLAVORS += wayland-gl
endif

GLMARK2_CONF_OPTS += \
	--prefix=/usr \
	--with-flavors=$(subst $(space),$(comma),$(GLMARK2_FLAVORS))

$(eval $(waf-package))
