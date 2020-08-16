################################################################################
#
# qt-webkit-kiosk
#
################################################################################

QT_WEBKIT_KIOSK_VERSION = a7720e50f2bd70aad99e0b465f5c4a57aca48127
QT_WEBKIT_KIOSK_SITE = https://github.com/sergey-dryabzhinsky/qt-webkit-kiosk.git
QT_WEBKIT_KIOSK_SITE_METHOD = git
QT_WEBKIT_KIOSK_DEPENDENCIES = qt5webkit qt5multimedia
QT_WEBKIT_KIOSK_LICENSE = LGPL-3.0
QT_WEBKIT_KIOSK_LICENSE_FILES = doc/lgpl.html

QT_WEBKIT_KIOSK_CONF_OPTS = PREFIX=/usr

define QT_WEBKIT_KIOSK_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/src -f Makefile.qt-webkit-kiosk \
		INSTALL_ROOT=$(TARGET_DIR) \
		install_target
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		INSTALL_ROOT=$(TARGET_DIR) \
		install_config \
		$(if $(BR2_PACKAGE_QT_WEBKIT_KIOSK_SOUNDS),install_sound)
endef

$(eval $(qmake-package))
