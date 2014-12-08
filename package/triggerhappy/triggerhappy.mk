################################################################################
#
# triggerhappy
#
################################################################################

TRIGGERHAPPY_VERSION = aac9f353a28c0f414b27ac54bbbb2292c152eedc
TRIGGERHAPPY_SITE = $(call github,wertarbyte,triggerhappy,$(TRIGGERHAPPY_VERSION))
TRIGGERHAPPY_LICENSE = GPLv3+
TRIGGERHAPPY_LICENSE_FILES = COPYING

define TRIGGERHAPPY_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) \
		LINUX_INPUT_H=$(STAGING_DIR)/usr/include/linux/input.h \
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

$(eval $(generic-package))
