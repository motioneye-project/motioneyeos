################################################################################
#
# qt5charts
#
################################################################################

# Qt5Charts does not follow Qt versionning for 5.6
ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
QT5CHARTS_VERSION = $(QT5_VERSION)
else
QT5CHARTS_VERSION = 2.1.3
endif
QT5CHARTS_SITE = $(QT5_SITE)
QT5CHARTS_SOURCE = qtcharts-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5CHARTS_VERSION).tar.xz
QT5CHARTS_DEPENDENCIES = qt5base
QT5CHARTS_INSTALL_STAGING = YES

QT5CHARTS_LICENSE = GPL-3.0
ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
QT5CHARTS_LICENSE_FILES = LICENSE.GPL3
endif

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
QT5CHARTS_DEPENDENCIES += qt5declarative
endif

define QT5CHARTS_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/bin/qmake)
endef

define QT5CHARTS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5CHARTS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_STATIC_LIBS),)
define QT5CHARTS_INSTALL_TARGET_LIBS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Charts*.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/plugins/* $(TARGET_DIR)/usr/lib/qt/plugins
endef
endif

# this is only built with quick support enabled
ifeq ($(BR2_PACKAGE_QT5DECLARATIVE_QUICK),y)
define QT5CHARTS_INSTALL_TARGET_QMLS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtCharts $(TARGET_DIR)/usr/qml/
endef
endif

ifeq ($(BR2_PACKAGE_QT5BASE_EXAMPLES),y)
define QT5CHARTS_INSTALL_TARGET_EXAMPLES
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/examples/charts* $(TARGET_DIR)/usr/lib/qt/examples/
endef
endif

define QT5CHARTS_INSTALL_TARGET_CMDS
	$(QT5CHARTS_INSTALL_TARGET_LIBS)
	$(QT5CHARTS_INSTALL_TARGET_QMLS)
	$(QT5CHARTS_INSTALL_TARGET_EXAMPLES)
endef

$(eval $(generic-package))
