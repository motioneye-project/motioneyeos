################################################################################
#
# qt5serialport
#
################################################################################

QT5SERIALPORT_VERSION = $(QT5_VERSION)
QT5SERIALPORT_SITE = $(QT5_SITE)
QT5SERIALPORT_SOURCE = qtserialport-opensource-src-$(QT5SERIALPORT_VERSION).tar.xz
QT5SERIALPORT_DEPENDENCIES = qt5base
QT5SERIALPORT_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5SERIALPORT_LICENSE = LGPLv2.1 or GPLv3.0
QT5SERIALPORT_LICENSE_FILES = LICENSE.GPL LICENSE.LGPL LGPL_EXCEPTION.txt
else
QT5SERIALPORT_LICENSE = Commercial license
QT5SERIALPORT_REDISTRIBUTE = NO
endif

define QT5SERIALPORT_CONFIGURE_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/qmake)
endef

define QT5SERIALPORT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5SERIALPORT_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_PREFER_STATIC_LIB),)
define QT5SERIALPORT_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5SerialPort.so.* $(TARGET_DIR)/usr/lib
endef
endif

$(eval $(generic-package))
