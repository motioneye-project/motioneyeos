################################################################################
#
# iptables
#
################################################################################

IPTABLES_VERSION = 1.4.20
IPTABLES_SOURCE = iptables-$(IPTABLES_VERSION).tar.bz2
IPTABLES_SITE = http://ftp.netfilter.org/pub/iptables
IPTABLES_INSTALL_STAGING = YES
IPTABLES_DEPENDENCIES = host-pkgconf \
	$(if $(BR2_PACKAGE_LIBNETFILTER_CONNTRACK),libnetfilter_conntrack)
IPTABLES_LICENSE = GPLv2
IPTABLES_LICENSE_FILES = COPYING
IPTABLES_CONF_OPT = --libexecdir=/usr/lib --with-kernel=$(STAGING_DIR)/usr
# Because of iptables-01-fix-static-link.patch
IPTABLES_AUTORECONF = YES

define IPTABLES_TARGET_SYMLINK_CREATE
	ln -sf xtables-multi $(TARGET_DIR)/usr/sbin/iptables
	ln -sf xtables-multi $(TARGET_DIR)/usr/sbin/iptables-save
	ln -sf xtables-multi $(TARGET_DIR)/usr/sbin/iptables-restore
endef

define IPTABLES_TARGET_IPV6_SYMLINK_CREATE
	ln -sf xtables-multi $(TARGET_DIR)/usr/sbin/ip6tables
	ln -sf xtables-multi $(TARGET_DIR)/usr/sbin/ip6tables-save
	ln -sf xtables-multi $(TARGET_DIR)/usr/sbin/ip6tables-restore
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
	rm -f $(TARGET_DIR)/usr/sbin/xtables-multi
	rm -rf $(TARGET_DIR)/usr/lib/xtables
endef

$(eval $(autotools-package))
