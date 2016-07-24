################################################################################
#
# odroid-scripts
#
################################################################################

ODROID_SCRIPTS_VERSION = a252de04562dcf8d8a4918a544b45a9e3d46d2fb
ODROID_SCRIPTS_SITE = $(call github,mdrjr,c2_bootini,$(ODROID_SCRIPTS_VERSION))
ODROID_SCRIPTS_LICENSE = unclear

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
define ODROID_SCRIPTS_INSTALL_UDEV_RULES
	$(INSTALL) -D -m 0644 $(@D)/10-odroid.rules \
		$(TARGET_DIR)/etc/udev/rules.d/10-odroid.rules
endef
endif

define ODROID_SCRIPTS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/c2_init.sh $(TARGET_DIR)/usr/sbin/odroidc2_init_fb.sh
	$(ODROID_SCRIPTS_INSTALL_UDEV_RULES)
endef

define ODROID_SCRIPTS_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(@D)/amlogic.service \
		$(TARGET_DIR)/usr/lib/systemd/system/odroidc2_fb.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/odroidc2_fb.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/odroidc2_fb.service
endef

define ODROID_SCRIPTS_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/odroid-scripts/S50odroidc2_fb \
		$(TARGET_DIR)/etc/init.d/S50odroidc2_fb
endef

$(eval $(generic-package))
