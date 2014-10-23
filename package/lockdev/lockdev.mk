################################################################################
#
# lockdev
#
################################################################################

LOCKDEV_VERSION = 1.0.3
LOCKDEV_SOURCE = lockdev_$(LOCKDEV_VERSION).orig.tar.gz
LOCKDEV_PATCH = lockdev_$(LOCKDEV_VERSION)-1.6.diff.gz
LOCKDEV_SITE = http://snapshot.debian.org/archive/debian/20141023T043132Z/pool/main/l/lockdev
LOCKDEV_LICENSE = LGPLv2.1
LOCKDEV_LICENSE_FILES = LICENSE
LOCKDEV_INSTALL_STAGING = YES

ifeq ($(BR2_PREFER_STATIC_LIB),y)
define LOCKDEV_BUILD_CMDS
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) static
endef

define LOCKDEV_INSTALL_STAGING_CMDS
	$(MAKE1) basedir=$(STAGING_DIR)/usr -C $(@D) install_dev
endef

else # BR2_PREFER_STATIC_LIB

define LOCKDEV_BUILD_CMDS
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) static shared
endef

define LOCKDEV_INSTALL_STAGING_CMDS
	$(MAKE1) basedir=$(STAGING_DIR)/usr -C $(@D) install_dev install_run
	ln -sf liblockdev.$(LOCKDEV_VERSION).so $(STAGING_DIR)/usr/lib/liblockdev.so
	ln -sf liblockdev.$(LOCKDEV_VERSION).so $(STAGING_DIR)/usr/lib/liblockdev.so.1
endef

define LOCKDEV_INSTALL_TARGET_CMDS
	$(MAKE1) basedir=$(TARGET_DIR)/usr -C $(@D) install_run
	ln -sf liblockdev.$(LOCKDEV_VERSION).so $(TARGET_DIR)/usr/lib/liblockdev.so.1
endef
endif # BR2_PREFER_STATIC_LIB

$(eval $(generic-package))
