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
	install -D -m 755 $(@D)/src/boa $(TARGET_DIR)/usr/sbin/boa
	install -D -m 755 $(@D)/src/boa_indexer $(TARGET_DIR)/usr/lib/boa/boa_indexer
	install -D -m 644 package/boa/boa.conf $(TARGET_DIR)/etc/boa/boa.conf
	install -D -m 644 package/boa/mime.types $(TARGET_DIR)/etc/mime.types
endef

define BOA_UNINSTALL_STAGING_CMDS
	# autotools calls uninstall-staging even if staging install
	# isn't enabled
endef

define BOA_UNINSTALL_TARGET_CMDS
	rm -rf $(TARGET_DIR)/usr/sbin/boa \
		$(TARGET_DIR)/usr/lib/boa/ \
		$(TARGET_DIR)/etc/mime.types $(TARGET_DIR)/etc/boa
endef

$(eval $(autotools-package))
