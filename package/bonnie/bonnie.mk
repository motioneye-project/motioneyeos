################################################################################
#
# bonnie
#
################################################################################

BONNIE_VERSION = 1.03e
BONNIE_SOURCE = bonnie++-$(BONNIE_VERSION).tgz
BONNIE_SITE = http://www.coker.com.au/bonnie++
BONNIE_LICENSE = GPL-2.0
BONNIE_LICENSE_FILES = copyright.txt

define BONNIE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/bonnie++ $(TARGET_DIR)/usr/sbin/bonnie++
	$(INSTALL) -D -m 755 $(@D)/zcav $(TARGET_DIR)/usr/sbin/zcav
endef

$(eval $(autotools-package))
