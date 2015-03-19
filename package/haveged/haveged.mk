################################################################################
#
# haveged
#
################################################################################

HAVEGED_VERSION = 1.9.1
HAVEGED_SITE = http://www.issihosts.com/haveged
HAVEGED_LICENSE = GPLv3+
HAVEGED_LICENSE_FILES = COPYING

define HAVEGED_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/haveged/S21haveged \
		$(TARGET_DIR)/etc/init.d/S21haveged
endef

define HAVEGED_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/haveged/haveged.service \
		$(TARGET_DIR)/usr/lib/systemd/system/haveged.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs /usr/lib/systemd/system/haveged.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/haveged.service
endef

$(eval $(autotools-package))
