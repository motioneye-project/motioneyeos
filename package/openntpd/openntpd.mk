#############################################################
#
# OpenNTPD
#
#############################################################

OPENNTPD_VERSION = 3.9p1
OPENNTPD_SITE = ftp://ftp.openbsd.org/pub/OpenBSD/OpenNTPD
OPENNTPD_CONF_OPT = --with-builtin-arc4random --disable-strip

define OPENNTPD_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/sbin/ntpd
	rm -f $(TARGET_DIR)/etc/ntpd.conf
	rm -f $(TARGET_DIR)/usr/share/man/man?/ntpd*
endef

$(eval $(autotools-package))
