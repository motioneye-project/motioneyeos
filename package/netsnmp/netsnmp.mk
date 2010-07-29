#############################################################
#
# netsnmp
#
#############################################################

NETSNMP_VERSION = 5.5
NETSNMP_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/net-snmp
NETSNMP_SOURCE = net-snmp-$(NETSNMP_VERSION).tar.gz
NETSNMP_INSTALL_STAGING = YES
NETSNMP_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
NETSNMP_LIBTOOL_PATCH = NO
NETSNMP_CONF_ENV = ac_cv_NETSNMP_CAN_USE_SYSCTL=yes
NETSNMP_CONF_OPT = --with-persistent-directory=/var/lib/snmp --disable-static \
		--with-defaults --enable-mini-agent --without-rpm \
		--with-logfile=none --without-kmem-usage $(DISABLE_IPV6) \
		--enable-as-needed --disable-debugging --without-perl-modules \
		--disable-embedded-perl --disable-perl-cc-checks \
		--with-sys-contact="root@unknown" \
		--with-sys-location="Unknown" \
		--with-mib-modules="host smux ucd-snmp/dlmod"

ifeq ($(BR2_ENDIAN),"BIG")
	NETSNMP_CONF_OPT += --with-endianness=big
else
	NETSNMP_CONF_OPT += --with-endianness=little
endif

# OpenSSL
ifeq ($(BR2_PACKAGE_OPENSSL),y)
	NETSNMP_DEPENDENCIES += openssl
	NETSNMP_CONF_OPT += \
		--with-openssl=$(STAGING_DIR)/usr/include/openssl
else
	NETSNMP_CONF_OPT += --without-openssl
endif

# Docs
ifneq ($(BR2_HAVE_DOCUMENTATION),y)
	NETSNMP_CONF_OPT += --disable-manuals
endif

define NETSNMP_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR) install
	$(INSTALL) -D -m 0755 package/netsnmp/S59snmpd \
		$(TARGET_DIR)/etc/init.d/S59snmpd
endef

define NETSNMP_UNINSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR) uninstall
	rm -f $(TARGET_DIR)/etc/init.d/S59snmpd
	rm -f $(TARGET_DIR)/usr/lib/libnetsnmp*
endef

$(eval $(call AUTOTARGETS,package,netsnmp))
