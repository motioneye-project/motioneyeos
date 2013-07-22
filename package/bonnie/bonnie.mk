################################################################################
#
# bonnie
#
################################################################################

BONNIE_VERSION = 1.03e
BONNIE_SOURCE = bonnie++-$(BONNIE_VERSION).tgz
BONNIE_SITE = http://www.coker.com.au/bonnie++/

define BONNIE_INSTALL_TARGET_CMDS
	install -D -m 755 $(@D)/bonnie++ $(TARGET_DIR)/usr/sbin/bonnie++
	install -D -m 755 $(@D)/zcav $(TARGET_DIR)/usr/sbin/zcav
endef

define BONNIE_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/sbin/bonnie++ $(TARGET_DIR)/usr/sbin/zcav
endef

$(eval $(autotools-package))
