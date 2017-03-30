################################################################################
#
# quazip
#
################################################################################

QUAZIP_VERSION = 0.7.3
QUAZIP_SITE = http://sourceforge.net/projects/quazip/files/quazip/$(QUAZIP_VERSION)
QUAZIP_INSTALL_STAGING = YES
QUAZIP_DEPENDENCIES = \
	zlib \
	$(if $(BR2_PACKAGE_QT),qt) \
	$(if $(BR2_PACKAGE_QT5),qt5base)
QUAZIP_LICENSE = LGPL-2.1
QUAZIP_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_QT5),y)
QUAZIP_QMAKE = $(QT5_QMAKE)
else
QUAZIP_QMAKE = $(QT_QMAKE)
endif

define QUAZIP_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(QUAZIP_QMAKE) PREFIX=/usr)
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
