#############################################################
#
# iptables
#
#############################################################
IPTABLES_VERSION = 1.4.6
IPTABLES_SOURCE = iptables-$(IPTABLES_VERSION).tar.bz2
IPTABLES_SITE = http://ftp.netfilter.org/pub/iptables

IPTABLES_CONF_OPT = --libexecdir=/usr/lib --with-kernel=$(LINUX_HEADERS_DIR)
ifneq ($(BR2_INET_IPV6),y)
IPTABLES_CONF_OPT += --disable-ipv6
endif

IPTABLES_AUTORECONF = YES
IPTABLES_LIBTOOL_PATCH = NO

$(eval $(call AUTOTARGETS,package,iptables))

$(IPTABLES_HOOK_POST_INSTALL): $(IPTABLES_TARGET_INSTALL_TARGET)
	ln -sf iptables-multi $(TARGET_DIR)/usr/sbin/iptables
	ln -sf iptables-multi $(TARGET_DIR)/usr/sbin/iptables-save
	ln -sf iptables-multi $(TARGET_DIR)/usr/sbin/iptables-restore
ifeq ($(BR2_INET_IPV6),y)
	ln -sf ip6tables-multi $(TARGET_DIR)/usr/sbin/ip6tables
	ln -sf ip6tables-multi $(TARGET_DIR)/usr/sbin/ip6tables-save
	ln -sf ip6tables-multi $(TARGET_DIR)/usr/sbin/ip6tables-restore
endif
	touch $@

$(IPTABLES_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(TARGET_DIR)/usr/bin/iptables-xml
	rm -f $(TARGET_DIR)/usr/sbin/iptables* $(TARGET_DIR)/usr/sbin/ip6tables*
	rm -rf $(TARGET_DIR)/usr/lib/xtables
	rm -f $(IPTABLES_TARGET_INSTALL_TARGET) $(IPTABLES_HOOK_POST_INSTALL)
