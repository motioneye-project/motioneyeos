################################################################################
#
# quazip
#
################################################################################

QUAZIP_VERSION = 0.8.1
QUAZIP_SITE = $(call github,stachenov,quazip,v$(QUAZIP_VERSION))
QUAZIP_INSTALL_STAGING = YES
QUAZIP_DEPENDENCIES = \
	zlib \
	qt5base
QUAZIP_LICENSE = LGPL-2.1
QUAZIP_LICENSE_FILES = COPYING

define QUAZIP_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(QT5_QMAKE) PREFIX=/usr)
endef

define QUAZIP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QUAZIP_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install INSTALL_ROOT=$(STAGING_DIR)
endef

define QUAZIP_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install INSTALL_ROOT=$(TARGET_DIR)
endef

$(eval $(generic-package))
