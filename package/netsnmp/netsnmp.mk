#############################################################
#
# netsnmp
#
#############################################################

NETSNMP_VERSION = 5.6
NETSNMP_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/net-snmp
NETSNMP_SOURCE = net-snmp-$(NETSNMP_VERSION).tar.gz
NETSNMP_INSTALL_STAGING = YES
NETSNMP_CONF_ENV = ac_cv_NETSNMP_CAN_USE_SYSCTL=yes
NETSNMP_CONF_OPT = --with-persistent-directory=/var/lib/snmp --disable-static \
		--with-defaults --enable-mini-agent --without-rpm \
		--with-logfile=none --without-kmem-usage $(DISABLE_IPV6) \
		--enable-as-needed --disable-debugging --without-perl-modules \
		--disable-embedded-perl --disable-perl-cc-checks \
		--disable-scripts --with-default-snmp-version="1" \
		--enable-silent-libtool --enable-mfd-rewrites \
		--with-sys-contact="root@localhost" \
		--with-sys-location="Unknown" \
		--with-mib-modules="host ucd-snmp/dlmod" \
		--with-out-mib-modules="disman/event disman/schedule utilities" \
		--with-out-transports="Unix"
NETSNMP_BLOAT_MIBS = BRIDGE DISMAN-EVENT DISMAN-SCHEDULE DISMAN-SCRIPT EtherLike RFC-1215 RFC1155-SMI RFC1213 SCTP SMUX

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

# Remove IPv6 MIBs if there's no IPv6
ifneq ($(BR2_INET_IPV6),y)
define NETSNMP_REMOVE_MIBS_IPV6
	rm -f $(TARGET_DIR)/usr/share/snmp/mibs/IPV6*
endef
endif

define NETSNMP_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR) install
	$(INSTALL) -D -m 0755 package/netsnmp/S59snmpd \
		$(TARGET_DIR)/etc/init.d/S59snmpd
	for mib in $(NETSNMP_BLOAT_MIBS); do \
		rm -f $(TARGET_DIR)/usr/share/snmp/mibs/$$mib-MIB.txt; \
	done
	$(NETSNMP_REMOVE_MIBS_IPV6)
endef

define NETSNMP_UNINSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR) uninstall
	rm -f $(TARGET_DIR)/etc/init.d/S59snmpd
	rm -f $(TARGET_DIR)/usr/lib/libnetsnmp*
endef

$(eval $(call AUTOTARGETS,package,netsnmp))
