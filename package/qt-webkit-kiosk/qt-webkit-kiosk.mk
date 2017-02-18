################################################################################
#
# qt-webkit-kiosk
#
################################################################################

QT_WEBKIT_KIOSK_VERSION = 7fe40a350abfbe5ec194e7c6c740f7099e8704cd
QT_WEBKIT_KIOSK_SITE = https://github.com/sergey-dryabzhinsky/qt-webkit-kiosk.git
QT_WEBKIT_KIOSK_SITE_METHOD = git
QT_WEBKIT_KIOSK_DEPENDENCIES = qt5webkit qt5multimedia
QT_WEBKIT_KIOSK_LICENSE = LGPLv3
QT_WEBKIT_KIOSK_LICENSE_FILES = doc/lgpl.html

define QT_WEBKIT_KIOSK_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(QT5_QMAKE) PREFIX=/usr)
endef

define QT_WEBKIT_KIOSK_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT_WEBKIT_KIOSK_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/src -f Makefile.qt-webkit-kiosk \
		INSTALL_ROOT=$(TARGET_DIR) \
		install_target
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		INSTALL_ROOT=$(TARGET_DIR) \
		install_config \
		$(if $(BR2_PACKAGE_QT_WEBKIT_KIOSK_SOUNDS),install_sound)
endef

$(eval $(generic-package))
