################################################################################
#
# iptables
#
################################################################################

IPTABLES_VERSION = 1.4.21
IPTABLES_SOURCE = iptables-$(IPTABLES_VERSION).tar.bz2
IPTABLES_SITE = http://ftp.netfilter.org/pub/iptables
IPTABLES_INSTALL_STAGING = YES
IPTABLES_DEPENDENCIES = host-pkgconf \
	$(if $(BR2_PACKAGE_LIBNETFILTER_CONNTRACK),libnetfilter_conntrack)
IPTABLES_LICENSE = GPLv2
IPTABLES_LICENSE_FILES = COPYING
# Building static causes ugly warnings on some plugins
IPTABLES_CONF_OPTS = --libexecdir=/usr/lib --with-kernel=$(STAGING_DIR)/usr \
	$(if $(BR2_STATIC_LIBS),,--disable-static)
# Because of iptables-01-fix-static-link.patch
IPTABLES_AUTORECONF = YES

# For connlabel match
ifeq ($(BR2_PACKAGE_LIBNETFILTER_CONNTRACK),y)
IPTABLES_DEPENDENCIES += libnetfilter_conntrack
endif

# For nfnl_osf
ifeq ($(BR2_PACKAGE_LIBNFNETLINK),y)
IPTABLES_DEPENDENCIES += libnfnetlink
endif

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

$(eval $(autotools-package))
