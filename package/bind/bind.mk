#############################################################
#
# bind
#
#############################################################
BIND_VERSION = 9.5.1-P3
BIND_SOURCE = bind-$(BIND_VERSION).tar.gz
BIND_SITE = ftp://ftp.isc.org/isc/bind9/$(BIND_VERSION)
BIND_LIBTOOL_PATCH = NO
BIND_DEPENDENCIES = uclibc
BIND_INSTALL_STAGING = NO
BIND_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
BIND_TARGET_SBINS = lwresd named named-checkconf named-checkzone
BIND_TARGET_SBINS += named-compilezone rndc rndc-confgen
BIND_TARGET_SBINS += dnssec-keygen dnssec-signzone
BIND_TARGET_BINS = dig host nslookup nsupdate
BIND_TARGET_LIBS = libbind9.* libdns.* libisccc.* libisccfg.* libisc.* liblwres.*
BIND_CONF_ENV =	BUILD_CC="$(TARGET_CC)" \
		BUILD_CFLAGS="$(TARGET_CFLAGS)"
BIND_CONF_OPT =	$(DISABLE_IPV6) \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--with-randomdev=/dev/urandom \
		--with-openssl=no \
		--with-libxml2=no \
		--with-pic \
		--with-libtool \
		--disable-epoll \
		--disable-threads

$(eval $(call AUTOTARGETS,package,bind))

$(BIND_HOOK_POST_INSTALL):
	rm -f $(TARGET_DIR)/usr/bin/isc-config.sh
ifneq ($(BR2_PACKAGE_BIND_TOOLS),y)
	rm -rf $(addprefix $(TARGET_DIR)/usr/bin/, $(BIND_TARGET_BINS))
endif
	$(INSTALL) -m 0755 -D package/bind/bind.sysvinit $(TARGET_DIR)/etc/init.d/S81named
	touch $@

$(BIND_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -rf $(addprefix $(TARGET_DIR)/usr/sbin/, $(BIND_TARGET_SBINS))
	rm -rf $(addprefix $(TARGET_DIR)/usr/bin/, $(BIND_TARGET_BINS))
	rm -rf $(addprefix $(TARGET_DIR)/usr/lib/, $(BIND_TARGET_LIBS))
	rm -f $(TARGET_DIR)/etc/init.d/S81named
	rm -f $(BIND_TARGET_INSTALL_TARGET) $(BIND_HOOK_POST_INSTALL)

