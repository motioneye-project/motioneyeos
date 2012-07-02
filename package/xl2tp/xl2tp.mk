#############################################################
#
# xl2tp
#
#############################################################
XL2TP_VERSION = 1.2.7
XL2TP_SOURCE = xl2tpd-$(XL2TP_VERSION).tar.gz
XL2TP_SITE = ftp://ftp.xelerance.com/xl2tpd/

XL2TP_DEPENDENCIES = libpcap

define XL2TP_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define XL2TP_INSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR) PREFIX=/usr -C $(@D) install
endef

define XL2TP_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/pfc
	rm -f $(TARGET_DIR)/usr/sbin/xl2tpd
	rm -f $(TARGET_DIR)/usr/share/man/man1/pfc.1
	rm -f $(TARGET_DIR)/usr/share/man/man8/xl2tpd.8
	rm -f $(TARGET_DIR)/usr/share/man/man5/xl2tpd.conf.5
	rm -f $(TARGET_DIR)/usr/share/man/man5/l2tp-secrets.5
endef

define XL2TP_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
