################################################################################
#
# qextserialport
#
################################################################################

QEXTSERIALPORT_VERSION = ada321a9ee463f628e7b781b8ed00ff219152158
QEXTSERIALPORT_SITE = $(call github,qextserialport,qextserialport,$(QEXTSERIALPORT_VERSION))
QEXTSERIALPORT_LICENSE = MIT
QEXTSERIALPORT_LICENSE_FILES = LICENSE.md
QEXTSERIALPORT_INSTALL_STAGING = YES

ifeq ($(BR2_STATIC_LIBS),y)
QEXTSERIALPORT_CONF_OPTS += CONFIG+=qesp_static
endif

QEXTSERIALPORT_DEPENDENCIES = qt5base

define QEXTSERIALPORT_CONFIGURE_CMDS
	cd $(@D); $(TARGET_MAKE_ENV) $(QT5_QMAKE) $(QEXTSERIALPORT_CONF_OPTS)
endef

define QEXTSERIALPORT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QEXTSERIALPORT_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
endef

ifeq ($(BR2_STATIC_LIBS),y)
QEXTSERIALPORT_INSTALL_TARGET = NO
else
define QEXTSERIALPORT_INSTALL_TARGET_CMDS
	cp -a $(@D)/*.so.* $(TARGET_DIR)/usr/lib
endef
endif

$(eval $(generic-package))
