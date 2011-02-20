#############################################################
#
# bind
#
#############################################################

BIND_VERSION = 9.5.2-P4
BIND_SITE = ftp://ftp.isc.org/isc/bind9/$(BIND_VERSION)
BIND_TARGET_SBINS = lwresd named named-checkconf named-checkzone
BIND_TARGET_SBINS += named-compilezone rndc rndc-confgen
BIND_TARGET_SBINS += dnssec-keygen dnssec-signzone
BIND_TARGET_BINS = dig host nslookup nsupdate
BIND_TARGET_LIBS = libbind9.* libdns.* libisccc.* libisccfg.* libisc.* liblwres.*
BIND_MAKE = $(MAKE1)
BIND_CONF_ENV =	BUILD_CC="$(TARGET_CC)" \
		BUILD_CFLAGS="$(TARGET_CFLAGS)"
BIND_CONF_OPT =	\
		--sysconfdir=/etc \
		--localstatedir=/var \
		--with-randomdev=/dev/urandom \
		--with-openssl=no \
		--with-libxml2=no \
		--with-pic \
		--with-libtool \
		--disable-epoll \
		--disable-threads

define BIND_TARGET_INSTALL_FIXES
	rm -f $(TARGET_DIR)/usr/bin/isc-config.sh
	$(INSTALL) -m 0755 -D package/bind/bind.sysvinit $(TARGET_DIR)/etc/init.d/S81named
endef

BIND_POST_INSTALL_TARGET_HOOKS += BIND_TARGET_INSTALL_FIXES

define BIND_TARGET_REMOVE_TOOLS
	rm -rf $(addprefix $(TARGET_DIR)/usr/bin/, $(BIND_TARGET_BINS))
endef

ifneq ($(BR2_PACKAGE_BIND_TOOLS),y)
BIND_POST_INSTALL_TARGET_HOOKS += BIND_TARGET_REMOVE_TOOLS
endif

define BIND_UNINSTALL_TARGET_CMDS
	rm -rf $(addprefix $(TARGET_DIR)/usr/sbin/, $(BIND_TARGET_SBINS))
	rm -rf $(addprefix $(TARGET_DIR)/usr/bin/, $(BIND_TARGET_BINS))
	rm -rf $(addprefix $(TARGET_DIR)/usr/lib/, $(BIND_TARGET_LIBS))
	rm -f $(TARGET_DIR)/etc/init.d/S81named
endef

$(eval $(call AUTOTARGETS,package,bind))
