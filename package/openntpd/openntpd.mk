################################################################################
#
# openntpd
#
################################################################################

OPENNTPD_VERSION = 5.7p4
OPENNTPD_SITE = http://ftp.openbsd.org/pub/OpenBSD/OpenNTPD
OPENNTPD_LICENSE = MIT-like, BSD-2c, BSD-3c
OPENNTPD_LICENSE_FILES = COPYING

define OPENNTPD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/openntpd/ntpd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/ntpd.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/ntpd.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/ntpd.service
endef

define OPENNTPD_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/openntpd/S49ntp \
		$(TARGET_DIR)/etc/init.d/S49ntp
endef

define OPENNTPD_USERS
	_ntp -1 _ntp -1 * - - - Network Time Protocol daemon
endef

$(eval $(autotools-package))
