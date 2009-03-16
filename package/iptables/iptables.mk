#############################################################
#
# iptables
#
#############################################################
IPTABLES_VERSION = 1.4.2
IPTABLES_SOURCE = iptables-$(IPTABLES_VERSION).tar.bz2
IPTABLES_SITE = http://ftp.netfilter.org/pub/iptables

IPTABLES_CONF_OPT = --libexecdir=/usr/lib
IPTABLES_INSTALL_TARGET = YES

IPTABLES_AUTORECONF = YES
IPTABLES_DEPENDENCIES =
IPTABLES_CONFIGURE_OPT = --with-kernel=$(LINUX_HEADERS_DIR)

$(eval $(call AUTOTARGETS,package,iptables))

$(IPTABLES_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(TARGET_DIR)/usr/bin/iptables-xml
	rm -f $(TARGET_DIR)/usr/sbin/iptables* $(TARGET_DIR)/usr/sbin/ip6tables*
	rm -rf $(TARGET_DIR)/usr/lib/xtables
	rm -f $(IPTABLES_TARGET_INSTALL_TARGET)
