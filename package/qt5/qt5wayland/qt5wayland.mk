################################################################################
#
# qt5wayland
#
################################################################################

QT5WAYLAND_VERSION = $(QT5_VERSION)
QT5WAYLAND_SITE = $(QT5_SITE)
QT5WAYLAND_SOURCE = qtwayland-opensource-src-$(QT5WAYLAND_VERSION).tar.xz
QT5WAYLAND_DEPENDENCIES = qt5base qt5declarative wayland
QT5WAYLAND_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_LIBXKBCOMMON),y)
QT5WAYLAND_DEPENDENCIES += libxkbcommon
endif

ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
QT5WAYLAND_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0 with exception(tools), GFDL-1.3 (docs)
QT5WAYLAND_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.GPL3-EXCEPT LICENSE.LGPL3 LICENSE.FDL
else
QT5WAYLAND_LICENSE = GPL-3.0 or LGPL-2.1 with exception or LGPL-3.0, GFDL-1.3 (docs)
QT5WAYLAND_LICENSE_FILES = LICENSE.GPLv3 LICENSE.LGPLv21 LGPL_EXCEPTION.txt LICENSE.LGPLv3 LICENSE.FDL
endif

ifeq ($(BR2_PACKAGE_QT5WAYLAND_COMPOSITOR),y)
QT5WAYLAND_QMAKEFLAGS += CONFIG+=wayland-compositor
endif

# The mesa's EGL/eglplatform.h header includes X11 headers unless the flag
# MESA_EGL_NO_X11_HEADERS is defined. Tell to not include X11 headers if
# the libxcb is not selected.
ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_EGL)x$(BR2_PACKAGE_LIBXCB),yx)
QT5WAYLAND_QMAKEFLAGS += QMAKE_CXXFLAGS+=-DMESA_EGL_NO_X11_HEADERS
endif

define QT5WAYLAND_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/bin/qmake $(QT5WAYLAND_QMAKEFLAGS))
endef

define QT5WAYLAND_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5WAYLAND_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_PACKAGE_QT5WAYLAND_COMPOSITOR),y)
ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
define QT5WAYLAND_INSTALL_COMPOSITOR
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5WaylandCompositor.so* $(TARGET_DIR)/usr/lib
endef
else
define QT5WAYLAND_INSTALL_COMPOSITOR
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Compositor.so* $(TARGET_DIR)/usr/lib
endef
endif
endif

define QT5WAYLAND_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5WaylandClient.so* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/plugins/wayland* $(TARGET_DIR)/usr/lib/qt/plugins
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/plugins/platforms/libqwayland* $(TARGET_DIR)/usr/lib/qt/plugins/platforms
	$(QT5WAYLAND_INSTALL_COMPOSITOR)
endef

$(eval $(generic-package))
