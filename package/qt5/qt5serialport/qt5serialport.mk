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
QT5SERIALPORT_LICENSE = GPLv2 or GPLv3 or LGPLv2.1 with exception or LGPLv3, GFDLv1.3 (docs)
QT5SERIALPORT_LICENSE_FILES = LICENSE.GPLv2 LICENSE.GPLv3 LICENSE.LGPLv21 LGPL_EXCEPTION.txt LICENSE.LGPLv3 LICENSE.FDL
else
QT5SERIALPORT_LICENSE = Commercial license
QT5SERIALPORT_REDISTRIBUTE = NO
endif

define QT5SERIALPORT_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT5SERIALPORT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5SERIALPORT_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_STATIC_LIBS),)
define QT5SERIALPORT_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5SerialPort.so.* $(TARGET_DIR)/usr/lib
endef
endif

$(eval $(generic-package))
