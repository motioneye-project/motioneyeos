################################################################################
#
# lockdev
#
################################################################################

LOCKDEV_MAJOR = 1
LOCKDEV_VERSION = $(LOCKDEV_MAJOR).0.3
LOCKDEV_SOURCE = lockdev_$(LOCKDEV_VERSION).orig.tar.gz
LOCKDEV_PATCH = lockdev_$(LOCKDEV_VERSION)-1.6.diff.gz
LOCKDEV_SITE = http://snapshot.debian.org/archive/debian/20141023T043132Z/pool/main/l/lockdev
LOCKDEV_LICENSE = LGPLv2.1
LOCKDEV_LICENSE_FILES = LICENSE
LOCKDEV_INSTALL_STAGING = YES

ifeq ($(BR2_STATIC_LIBS),y)
LOCKDEV_BUILD_ARGS = static
LOCKDEV_INSTALL_ARGS = install_static
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
LOCKDEV_BUILD_ARGS = static shared
LOCKDEV_INSTALL_ARGS = install_run install_static
else # BR2_SHARED_LIBS
LOCKDEV_BUILD_ARGS = shared
LOCKDEV_INSTALL_ARGS = install_run
endif

ifeq ($(BR2_SHARED_STATIC_LIBS)$(BR2_SHARED_LIBS),y)
define LOCKDEV_CREATE_LINKS_STAGING
	ln -sf liblockdev.$(LOCKDEV_VERSION).so $(STAGING_DIR)/usr/lib/liblockdev.so
	ln -sf liblockdev.$(LOCKDEV_VERSION).so $(STAGING_DIR)/usr/lib/liblockdev.so.$(LOCKDEV_MAJOR)
endef

define LOCKDEV_CREATE_LINKS_TARGET
	ln -sf liblockdev.$(LOCKDEV_VERSION).so $(TARGET_DIR)/usr/lib/liblockdev.so.$(LOCKDEV_MAJOR)
endef
endif

define LOCKDEV_BUILD_CMDS
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) $(LOCKDEV_BUILD_ARGS)
endef

define LOCKDEV_INSTALL_STAGING_CMDS
	$(MAKE1) basedir=$(STAGING_DIR)/usr -C $(@D) $(LOCKDEV_INSTALL_ARGS) install_dev
	$(LOCKDEV_CREATE_LINKS_STAGING)
endef

define LOCKDEV_INSTALL_TARGET_CMDS
	$(MAKE1) basedir=$(TARGET_DIR)/usr -C $(@D) $(LOCKDEV_INSTALL_ARGS)
	$(LOCKDEV_CREATE_LINKS_TARGET)
endef

$(eval $(generic-package))
