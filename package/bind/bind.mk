#############################################################
#
# bind
#
#############################################################

BIND_VERSION = 9.6-ESV-R7-P2
BIND_SITE = ftp://ftp.isc.org/isc/bind9/$(BIND_VERSION)
BIND_MAKE = $(MAKE1)
BIND_TARGET_SBINS = lwresd named named-checkconf named-checkzone
BIND_TARGET_SBINS += named-compilezone rndc rndc-confgen dnssec-dsfromkey
BIND_TARGET_SBINS += dnssec-keyfromlabel dnssec-keygen dnssec-signzone
BIND_TARGET_BINS = dig host nslookup nsupdate
BIND_TARGET_LIBS = libbind9.* libdns.* libisc.* libisccc.* libisccfg.* liblwres.*
BIND_CONF_ENV =	BUILD_CC="$(TARGET_CC)" \
		BUILD_CFLAGS="$(TARGET_CFLAGS)"
BIND_CONF_OPT =	--sysconfdir=/etc \
		--localstatedir=/var \
		--with-randomdev=/dev/urandom \
		--enable-epoll --with-libtool

ifeq ($(BR2_PACKAGE_LIBXML2),y)
	BIND_CONF_OPT += --with-libxml2=$(STAGING_DIR)/usr
	BIND_DEPENDENCIES += libxml2
else
	BIND_CONF_OPT += --with-libxml2=no
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
	BIND_DEPENDENCIES += openssl
	BIND_CONF_OPT += --with-openssl=$(STAGING_DIR)/usr
else
	BIND_CONF_OPT += --with-openssl=no
endif

define BIND_TARGET_INSTALL_FIXES
	rm -f $(TARGET_DIR)/usr/bin/isc-config.sh
	$(INSTALL) -m 0755 -D package/bind/bind.sysvinit $(TARGET_DIR)/etc/init.d/S81named
endef

BIND_POST_INSTALL_TARGET_HOOKS += BIND_TARGET_INSTALL_FIXES

define BIND_TARGET_REMOVE_SERVER
	rm -rf $(addprefix $(TARGET_DIR)/usr/sbin/, $(BIND_TARGET_SBINS))
endef

define BIND_TARGET_REMOVE_TOOLS
	rm -rf $(addprefix $(TARGET_DIR)/usr/bin/, $(BIND_TARGET_BINS))
endef

ifneq ($(BR2_PACKAGE_BIND_SERVER),y)
BIND_POST_INSTALL_TARGET_HOOKS += BIND_TARGET_REMOVE_SERVER
endif

ifneq ($(BR2_PACKAGE_BIND_TOOLS),y)
BIND_POST_INSTALL_TARGET_HOOKS += BIND_TARGET_REMOVE_TOOLS
endif

define BIND_UNINSTALL_TARGET_CMDS
	$(BIND_TARGET_REMOVE_SERVER)
	$(BIND_TARGET_REMOVE_TOOLS)
	rm -rf $(addprefix $(TARGET_DIR)/usr/lib/, $(BIND_TARGET_LIBS))
	rm -f $(TARGET_DIR)/etc/init.d/S81named
endef

$(eval $(autotools-package))
