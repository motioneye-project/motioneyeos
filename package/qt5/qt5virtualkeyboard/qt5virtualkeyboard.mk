################################################################################
#
# qt5virtualkeyboard
#
################################################################################

# Module does not follow Qt versionning for 5.6
ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
QT5VIRTUALKEYBOARD_VERSION = $(QT5_VERSION)
else
QT5VIRTUALKEYBOARD_VERSION = 2.0
endif
QT5VIRTUALKEYBOARD_SITE = $(QT5_SITE)
QT5VIRTUALKEYBOARD_SOURCE = qtvirtualkeyboard-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5VIRTUALKEYBOARD_VERSION).tar.xz
QT5VIRTUALKEYBOARD_DEPENDENCIES = qt5base qt5declarative qt5svg
QT5VIRTUALKEYBOARD_INSTALL_STAGING = YES

QT5VIRTUALKEYBOARD_LICENSE = GPL-3.0
ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
QT5VIRTUALKEYBOARD_LICENSE_FILES = LICENSE.GPL3
endif

QT5VIRTUALKEYBOARD_LANGUAGE_LAYOUTS = $(call qstrip,$(BR2_PACKAGE_QT5VIRTUALKEYBOARD_LANGUAGE_LAYOUTS))
ifneq ($(strip $(QT5VIRTUALKEYBOARD_LANGUAGE_LAYOUTS)),)
QT5VIRTUALKEYBOARD_QMAKEFLAGS += CONFIG+="$(foreach lang,$(QT5VIRTUALKEYBOARD_LANGUAGE_LAYOUTS),lang-$(lang))"

ifneq ($(filter ja_JP all,$(QT5VIRTUALKEYBOARD_LANGUAGE_LAYOUTS)),)
QT5VIRTUALKEYBOARD_LICENSE += , Apache-2.0 (openwnn)
ifeq ($(BR2_PACKAGE_QT5_VERSION_5_6),y)
QT5VIRTUALKEYBOARD_LICENSE_FILES += src/virtualkeyboard/3rdparty/openwnn/NOTICE
else
QT5VIRTUALKEYBOARD_LICENSE_FILES += src/plugins/openwnn/3rdparty/openwnn/NOTICE
endif
endif

ifneq ($(filter zh_CN all,$(QT5VIRTUALKEYBOARD_LANGUAGE_LAYOUTS)),)
QT5VIRTUALKEYBOARD_LICENSE += , Apache-2.0 (pinyin)
ifeq ($(BR2_PACKAGE_QT5_VERSION_5_6),y)
QT5VIRTUALKEYBOARD_3RDPARTY_PARTS = YES
QT5VIRTUALKEYBOARD_LICENSE_FILES += src/virtualkeyboard/3rdparty/pinyin/NOTICE
else
QT5VIRTUALKEYBOARD_LICENSE_FILES += src/plugins/pinyin/3rdparty/pinyin/NOTICE
endif
endif

ifneq ($(filter zh_TW all,$(QT5VIRTUALKEYBOARD_LANGUAGE_LAYOUTS)),)
QT5VIRTUALKEYBOARD_LICENSE += , Apache-2.0 (tcime), BSD-3-Clause (tcime)
ifeq ($(BR2_PACKAGE_QT5_VERSION_5_6),y)
QT5VIRTUALKEYBOARD_3RDPARTY_PARTS = YES
QT5VIRTUALKEYBOARD_LICENSE_FILES += src/virtualkeyboard/3rdparty/tcime/COPYING
else
QT5VIRTUALKEYBOARD_LICENSE_FILES += src/plugins/tcime/3rdparty/tcime/COPYING
endif
endif
endif

ifeq ($(BR2_PACKAGE_QT5VIRTUALKEYBOARD_HANDWRITING),y)
QT5VIRTUALKEYBOARD_3RDPARTY_PARTS = YES
QT5VIRTUALKEYBOARD_QMAKEFLAGS += CONFIG+=handwriting
QT5VIRTUALKEYBOARD_LICENSE += , MIT (lipi-toolkit)
ifeq ($(BR2_PACKAGE_QT5_VERSION_5_6),y)
QT5VIRTUALKEYBOARD_LICENSE_FILES += src/virtualkeyboard/3rdparty/lipi-toolkit/license.txt
else
QT5VIRTUALKEYBOARD_LICENSE_FILES += src/plugins/lipi-toolkit/3rdparty/lipi-toolkit/MIT_LICENSE.txt
endif
endif

ifeq ($(BR2_PACKAGE_QT5VIRTUALKEYBOARD_ARROW_KEY_NAVIGATION),y)
QT5VIRTUALKEYBOARD_QMAKEFLAGS += CONFIG+=arrow-key-navigation
endif

ifeq ($(QT5VIRTUALKEYBOARD_3RDPARTY_PARTS),YES)
define QT5VIRTUALKEYBOARD_INSTALL_TARGET_3RDPARTY_PARTS
	cp -dpfr $(STAGING_DIR)/usr/qtvirtualkeyboard $(TARGET_DIR)/usr
endef
endif

define QT5VIRTUALKEYBOARD_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/bin/qmake $(QT5VIRTUALKEYBOARD_QMAKEFLAGS))
endef

define QT5VIRTUALKEYBOARD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5VIRTUALKEYBOARD_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
endef

ifeq ($(BR2_PACKAGE_QT5_VERSION_5_6),y)
define QT5VIRTUALKEYBOARD_INSTALL_TARGET_QML
	mkdir -p $(TARGET_DIR)/usr/qml/QtQuick/Enterprise
	cp -dpfr $(STAGING_DIR)/usr/qml/QtQuick/Enterprise/VirtualKeyboard $(TARGET_DIR)/usr/qml/QtQuick/Enterprise/
endef
else
define QT5VIRTUALKEYBOARD_INSTALL_TARGET_QML
	mkdir -p $(TARGET_DIR)/usr/qml/QtQuick
	cp -dpfr $(STAGING_DIR)/usr/qml/QtQuick/VirtualKeyboard $(TARGET_DIR)/usr/qml/QtQuick/
endef
endif

ifeq ($(BR2_PACKAGE_QT5BASE_EXAMPLES),y)
define QT5VIRTUALKEYBOARD_INSTALL_TARGET_EXAMPLES
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/examples/virtualkeyboard $(TARGET_DIR)/usr/lib/qt/examples/
endef
endif

ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST):$(BR2_STATIC_LIBS),y:)
define QT5VIRTUALKEYBOARD_INSTALL_TARGET_LIBS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5VirtualKeyboard*.so.* $(TARGET_DIR)/usr/lib
endef
endif

define QT5VIRTUALKEYBOARD_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/qt/plugins/platforminputcontexts
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/plugins/platforminputcontexts/libqtvirtualkeyboardplugin.so \
		$(TARGET_DIR)/usr/lib/qt/plugins/platforminputcontexts
	$(QT5VIRTUALKEYBOARD_INSTALL_TARGET_LIBS)
	$(QT5VIRTUALKEYBOARD_INSTALL_TARGET_QML)
	$(QT5VIRTUALKEYBOARD_INSTALL_TARGET_3RDPARTY_PARTS)
	$(QT5VIRTUALKEYBOARD_INSTALL_TARGET_EXAMPLES)
endef

$(eval $(generic-package))
