################################################################################
#
# babeld
#
################################################################################

BABELD_VERSION = 1.8.4
BABELD_SITE = http://www.pps.univ-paris-diderot.fr/~jch/software/files
BABELD_LICENSE = MIT
BABELD_LICENSE_FILES = LICENCE

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
endef

$(eval $(generic-package))
