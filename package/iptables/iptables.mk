#############################################################
#
# iptables
#
#############################################################

IPTABLES_VERSION = 1.4.10
IPTABLES_SOURCE = iptables-$(IPTABLES_VERSION).tar.bz2
IPTABLES_SITE = http://ftp.netfilter.org/pub/iptables
IPTABLES_INSTALL_STAGING = YES
IPTABLES_AUTORECONF = YES
IPTABLES_DEPENDENCIES = host-pkg-config

IPTABLES_CONF_OPT = --libexecdir=/usr/lib --with-kernel=$(LINUX_HEADERS_DIR)

define IPTABLES_TARGET_SYMLINK_CREATE
	ln -sf iptables-multi $(TARGET_DIR)/usr/sbin/iptables
	ln -sf iptables-multi $(TARGET_DIR)/usr/sbin/iptables-save
	ln -sf iptables-multi $(TARGET_DIR)/usr/sbin/iptables-restore
endef

define IPTABLES_TARGET_IPV6_SYMLINK_CREATE
	ln -sf ip6tables-multi $(TARGET_DIR)/usr/sbin/ip6tables
	ln -sf ip6tables-multi $(TARGET_DIR)/usr/sbin/ip6tables-save
	ln -sf ip6tables-multi $(TARGET_DIR)/usr/sbin/ip6tables-restore
endef

define IPTABLES_TARGET_IPV6_REMOVE
	rm -f $(TARGET_DIR)/usr/lib/libip6tc.*
endef

IPTABLES_POST_INSTALL_TARGET_HOOKS += IPTABLES_TARGET_SYMLINK_CREATE

ifeq ($(BR2_INET_IPV6),y)
IPTABLES_POST_INSTALL_TARGET_HOOKS += IPTABLES_TARGET_IPV6_SYMLINK_CREATE
else
IPTABLES_POST_INSTALL_TARGET_HOOKS += IPTABLES_TARGET_IPV6_REMOVE
endif

define IPTABLES_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/iptables-xml
	rm -f $(TARGET_DIR)/usr/sbin/iptables* $(TARGET_DIR)/usr/sbin/ip6tables*
	rm -rf $(TARGET_DIR)/usr/lib/xtables
endef

$(eval $(call AUTOTARGETS,package,iptables))
