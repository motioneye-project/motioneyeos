################################################################################
#
# babeld
#
################################################################################

BABELD_VERSION = 1.7.1
BABELD_SITE = http://www.pps.univ-paris-diderot.fr/~jch/software/files
BALELD_LICENSE = MIT
BALELD_LICENSE_FILES = LICENSE

define BABELD_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define BABELD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/babeld $(TARGET_DIR)/usr/sbin/babeld
endef

define BABELD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/babeld/S50babeld \
		$(TARGET_DIR)/etc/init.d/S50babeld
endef

define BABELD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/babeld/babeld.service \
		$(TARGET_DIR)/usr/lib/systemd/system/babeld.service

	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants

	ln -fs ../../../../usr/lib/systemd/system/babeld.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/babeld.service
endef

$(eval $(generic-package))
