################################################################################
#
# triggerhappy
#
################################################################################

TRIGGERHAPPY_VERSION = b822888066129350e51ad79f1cf307fa38dae4f7
TRIGGERHAPPY_SITE = $(call github,wertarbyte,triggerhappy,$(TRIGGERHAPPY_VERSION))
TRIGGERHAPPY_LICENSE = GPL-3.0+
TRIGGERHAPPY_LICENSE_FILES = COPYING
TRIGGERHAPPY_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
TRIGGERHAPPY_DEPENDENCIES += systemd
endif

define TRIGGERHAPPY_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) PKGCONFIG="$(PKG_CONFIG_HOST_BINARY)" \
		-C $(@D) thd th-cmd
endef

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
define TRIGGERHAPPY_INSTALL_UDEV_RULE
	$(INSTALL) -D -m 0644 $(@D)/udev/triggerhappy-udev.rules \
		$(TARGET_DIR)/lib/udev/rules.d/triggerhappy.rules
endef
endif

define TRIGGERHAPPY_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/etc/triggerhappy/triggers.d
	$(INSTALL) -D -m 0755 $(@D)/thd $(TARGET_DIR)/usr/sbin/thd
	$(INSTALL) -D -m 0755 $(@D)/th-cmd $(TARGET_DIR)/usr/sbin/th-cmd
	$(TRIGGERHAPPY_INSTALL_UDEV_RULE)
endef

define TRIGGERHAPPY_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/triggerhappy/S10triggerhappy \
		$(TARGET_DIR)/etc/init.d/S10triggerhappy
endef

define TRIGGERHAPPY_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/triggerhappy/triggerhappy.service \
		$(TARGET_DIR)/usr/lib/systemd/system/triggerhappy.service
endef

$(eval $(generic-package))
