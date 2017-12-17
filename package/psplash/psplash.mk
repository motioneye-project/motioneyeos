################################################################################
#
# psplash
#
################################################################################

PSPLASH_VERSION = 5b3c1cc28f5abdc2c33830150b48b278cc4f7bca
PSPLASH_SITE = git://git.yoctoproject.org/psplash
PSPLASH_LICENSE = GPL-2.0+
PSPLASH_AUTORECONF = YES

define PSPLASH_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/psplash/psplash-start.service \
		$(TARGET_DIR)/usr/lib/systemd/system/psplash-start.service
	$(INSTALL) -d $(TARGET_DIR)/etc/systemd/system/sysinit.target.wants
	ln -sf  ../../../../usr/lib/systemd/system/psplash-start.service \
		$(TARGET_DIR)/etc/systemd/system/sysinit.target.wants/

	$(INSTALL) -D -m 644 package/psplash/psplash-quit.service \
		$(TARGET_DIR)/usr/lib/systemd/system/psplash-quit.service
	$(INSTALL) -d $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf  ../../../../usr/lib/systemd/system/psplash-quit.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/
endef

$(eval $(autotools-package))
