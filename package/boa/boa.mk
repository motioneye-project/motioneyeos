################################################################################
#
# boa
#
################################################################################

BOA_VERSION = 0.94.14rc21
BOA_SITE = http://www.boa.org/
BOA_LICENSE = GPLv2+
BOA_LICENSE_FILES = COPYING

define BOA_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/src/boa $(TARGET_DIR)/usr/sbin/boa
	$(INSTALL) -D -m 755 $(@D)/src/boa_indexer $(TARGET_DIR)/usr/lib/boa/boa_indexer
	$(INSTALL) -D -m 644 package/boa/boa.conf $(TARGET_DIR)/etc/boa/boa.conf
	$(INSTALL) -D -m 644 package/boa/mime.types $(TARGET_DIR)/etc/mime.types
endef

$(eval $(autotools-package))
