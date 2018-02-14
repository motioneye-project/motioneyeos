################################################################################
#
# qt5webengine
#
################################################################################

QT5WEBENGINE_VERSION = $(QT5_VERSION)
QT5WEBENGINE_SITE = $(QT5_SITE)
QT5WEBENGINE_SOURCE = qtwebengine-opensource-src-$(QT5WEBENGINE_VERSION).tar.xz
QT5WEBENGINE_DEPENDENCIES = ffmpeg libglib2 libvpx opus webp qt5base \
	qt5declarative qt5webchannel host-bison host-flex host-gperf \
	host-pkgconf host-python
QT5WEBENGINE_INSTALL_STAGING = YES

include package/qt5/qt5webengine/chromium.inc
QT5WEBENGINE_LICENSE = GPL-2.0 or LGPL-3.0 or GPL-3.0 or GPL-3.0 with exception
QT5WEBENGINE_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.GPL3-EXCEPT \
	LICENSE.GPLv3 LICENSE.LGPL3 $(CHROMIUM_LICENSE_FILES)

ifeq ($(BR2_PACKAGE_QT5BASE_XCB),y)
QT5WEBENGINE_DEPENDENCIES += xlib_libXScrnSaver xlib_libXcomposite \
	xlib_libXcursor xlib_libXi xlib_libXrandr xlib_libXtst
endif

QT5WEBENGINE_QMAKEFLAGS += WEBENGINE_CONFIG+=use_system_ffmpeg

ifeq ($(BR2_PACKAGE_QT5WEBENGINE_PROPRIETARY_CODECS),y)
QT5WEBENGINE_QMAKEFLAGS += WEBENGINE_CONFIG+=use_proprietary_codecs
endif

ifeq ($(BR2_PACKAGE_QT5WEBENGINE_ALSA),y)
QT5WEBENGINE_DEPENDENCIES += alsa-lib
else
QT5WEBENGINE_QMAKEFLAGS += QT_CONFIG-=alsa
endif

# QtWebengine's build system uses python, but only supports python2. We work
# around this by forcing python2 early in the PATH, via a python->python2
# symlink.
QT5WEBENGINE_ENV = PATH=$(@D)/host-bin:$(BR_PATH)
define QT5WEBENGINE_PYTHON2_SYMLINK
	mkdir -p $(@D)/host-bin
	ln -sf $(HOST_DIR)/bin/python2 $(@D)/host-bin/python
endef
QT5WEBENGINE_PRE_CONFIGURE_HOOKS += QT5WEBENGINE_PYTHON2_SYMLINK

define QT5WEBENGINE_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(QT5WEBENGINE_ENV) $(HOST_DIR)/bin/qmake $(QT5WEBENGINE_QMAKEFLAGS))
endef

define QT5WEBENGINE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(QT5WEBENGINE_ENV) $(MAKE) -C $(@D)
endef

define QT5WEBENGINE_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(QT5WEBENGINE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

define QT5WEBENGINE_INSTALL_TARGET_QMLS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtWebEngine $(TARGET_DIR)/usr/qml/
endef

ifeq ($(BR2_PACKAGE_QT5BASE_EXAMPLES),y)
define QT5WEBENGINE_INSTALL_TARGET_EXAMPLES
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/examples/webengine* $(TARGET_DIR)/usr/lib/qt/examples/
endef
endif

ifneq ($(BR2_STATIC_LIBS),y)
define QT5WEBENGINE_INSTALL_TARGET_LIBS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5WebEngine*.so.* $(TARGET_DIR)/usr/lib
	cp -dpf $(STAGING_DIR)/usr/libexec/QtWebEngineProcess $(TARGET_DIR)/usr/libexec/
	cp -dpfr $(STAGING_DIR)/usr/resources/ $(TARGET_DIR)/usr/
	mkdir -p $(TARGET_DIR)/usr/translations/qtwebengine_locales/
	cp -dpfr $(STAGING_DIR)/usr/translations/qtwebengine_locales $(TARGET_DIR)/usr/translations/qtwebengine_locales/
endef
endif

define QT5WEBENGINE_INSTALL_TARGET_CMDS
	$(QT5WEBENGINE_INSTALL_TARGET_LIBS)
	$(QT5WEBENGINE_INSTALL_TARGET_QMLS)
	$(QT5WEBENGINE_INSTALL_TARGET_EXAMPLES)
endef

$(eval $(generic-package))
