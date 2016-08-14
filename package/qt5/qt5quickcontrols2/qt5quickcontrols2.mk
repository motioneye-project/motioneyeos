################################################################################
#
# qt5quickcontrols2
#
################################################################################

QT5QUICKCONTROLS2_VERSION = $(QT5_VERSION)
QT5QUICKCONTROLS2_SITE = $(QT5_SITE)
QT5QUICKCONTROLS2_SOURCE = qtquickcontrols2-opensource-src-$(QT5QUICKCONTROLS2_VERSION).tar.xz
QT5QUICKCONTROLS2_DEPENDENCIES = qt5base qt5declarative
QT5QUICKCONTROLS2_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5QUICKCONTROLS2_LICENSE = GPLv3 or LGPLv3, GFDLv1.3 (docs)
QT5QUICKCONTROLS2_LICENSE_FILES = LICENSE.GPLv3 LICENSE.LGPLv3 LICENSE.FDL
else
QT5QUICKCONTROLS2_LICENSE = Commercial license
QT5QUICKCONTROLS2_REDISTRIBUTE = NO
endif

define QT5QUICKCONTROLS2_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT5QUICKCONTROLS2_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5QUICKCONTROLS2_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
endef

define QT5QUICKCONTROLS2_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5LabsTemplates.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/qml/Qt/labs/controls $(TARGET_DIR)/usr/qml/Qt/labs
	cp -dpfr $(STAGING_DIR)/usr/qml/Qt/labs/calendar $(TARGET_DIR)/usr/qml/Qt/labs
	cp -dpfr $(STAGING_DIR)/usr/qml/Qt/labs/templates $(TARGET_DIR)/usr/qml/Qt/labs
endef

$(eval $(generic-package))
