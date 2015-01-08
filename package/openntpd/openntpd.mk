################################################################################
#
# openntpd
#
################################################################################

OPENNTPD_VERSION = 5.7p1
OPENNTPD_SITE = http://ftp.openbsd.org/pub/OpenBSD/OpenNTPD
OPENNTPD_LICENSE = MIT-like, BSD-2c, BSD-3c
OPENNTPD_LICENSE_FILES = LICENCE

define OPENNTPD_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/openntpd/S49ntp \
		$(TARGET_DIR)/etc/init.d/S49ntp
endef

define OPENNTPD_USERS
	_ntp -1 _ntp -1 * - - - Network Time Protocol daemon
endef

$(eval $(autotools-package))
