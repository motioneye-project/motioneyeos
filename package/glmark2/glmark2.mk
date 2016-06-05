################################################################################
#
# glmark2
#
################################################################################

GLMARK2_VERSION = fa71af2dfab711fac87b9504b6fc9862f44bf72a
GLMARK2_SITE = $(call github,glmark2,glmark2,$(GLMARK2_VERSION))
GLMARK2_LICENSE = GPLv3+ SGIv1
GLMARK2_LICENSE_FILES = COPYING COPYING.SGI
GLMARK2_DEPENDENCIES = host-pkgconf host-python jpeg libpng \
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

define GLMARK2_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		$(GLMARK2_CONF_ENV) \
		$(HOST_DIR)/usr/bin/python2 ./waf configure $(GLMARK2_CONF_OPTS) \
	)
endef

define GLMARK2_BUILD_CMDS
	cd $(@D) && $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/python2 ./waf
endef

define GLMARK2_INSTALL_TARGET_CMDS
	cd $(@D) && $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/python2 ./waf install --destdir=$(TARGET_DIR)
endef

$(eval $(generic-package))
