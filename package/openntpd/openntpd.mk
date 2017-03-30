################################################################################
#
# openntpd
#
################################################################################

OPENNTPD_VERSION = 6.0p1
OPENNTPD_SITE = http://ftp.openbsd.org/pub/OpenBSD/OpenNTPD
OPENNTPD_LICENSE = MIT-like, BSD-2-Clause, BSD-3-Clause
OPENNTPD_LICENSE_FILES = COPYING
# Ships a beta libtool version hence our patch doesn't apply.
OPENNTPD_AUTORECONF = YES

# openntpd uses pthread functions for arc4random emulation but forgets
# to use -pthread
OPENNTPD_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -pthread"

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
