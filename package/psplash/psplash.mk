################################################################################
#
# psplash
#
################################################################################

PSPLASH_VERSION = 14c8f7b705de944beb4de3f296506d80871e410f
PSPLASH_SITE = git://git.yoctoproject.org/psplash
PSPLASH_LICENSE = GPLv2+
PSPLASH_AUTORECONF = YES

define PSPLASH_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/psplash/psplash-start.service \
		$(TARGET_DIR)/etc/systemd/system/psplash-start.service
	$(INSTALL) -d $(TARGET_DIR)/etc/systemd/system/sysinit.target.wants
	ln -sf  ../psplash-start.service \
		 $(TARGET_DIR)/etc/systemd/system/sysinit.target.wants/

	$(INSTALL) -D -m 644 package/psplash/psplash-quit.service \
		$(TARGET_DIR)/etc/systemd/system/psplash-quit.service
	$(INSTALL) -d $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf  ../psplash-quit.service \
		 $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/
endef

$(eval $(autotools-package))
