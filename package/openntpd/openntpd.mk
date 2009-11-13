#############################################################
#
# OpenNTPD
#
#############################################################

OPENNTPD_VERSION = 3.9p1
OPENNTPD_SITE = ftp://ftp.openbsd.org/pub/OpenBSD/OpenNTPD
OPENNTPD_CONF_OPT = --with-builtin-arc4random --disable-strip
OPENNTPD_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package,openntpd))

$(OPENNTPD_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(TARGET_DIR)/usr/sbin/ntpd
	rm -f $(TARGET_DIR)/etc/ntpd.conf
	rm -f $(TARGET_DIR)/usr/share/man/man?/ntpd*
	rm -f $(OPENNTPD_TARGET_INSTALL_TARGET) $(OPENNTPD_HOOK_POST_INSTALL)
