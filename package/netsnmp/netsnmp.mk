#############################################################
#
# netsnmp
#
#############################################################
NETSNMP_VERSION:=5.1.2
NETSNMP_PATCH_VERSION:=6.2
NETSNMP_URL:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/net-snmp/
NETSNMP_DIR:=$(BUILD_DIR)/net-snmp-$(NETSNMP_VERSION)
NETSNMP_SOURCE:=net-snmp-$(NETSNMP_VERSION).tar.gz
NETSNMP_PATCH1:=net-snmp_$(NETSNMP_VERSION)-$(NETSNMP_PATCH_VERSION).diff.gz
NETSNMP_PATCH1_URL:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/n/net-snmp/

$(DL_DIR)/$(NETSNMP_SOURCE):
	$(WGET) -P $(DL_DIR) $(NETSNMP_URL)/$(NETSNMP_SOURCE)

$(DL_DIR)/$(NETSNMP_PATCH1):
	$(WGET) -P $(DL_DIR) $(NETSNMP_PATCH1_URL)/$(NETSNMP_PATCH1)

$(NETSNMP_DIR)/.unpacked: $(DL_DIR)/$(NETSNMP_SOURCE) $(DL_DIR)/$(NETSNMP_PATCH1)
	$(ZCAT) $(DL_DIR)/$(NETSNMP_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(ZCAT) $(DL_DIR)/$(NETSNMP_PATCH1) | patch -p1 -d $(NETSNMP_DIR)
	toolchain/patch-kernel.sh $(NETSNMP_DIR) package/netsnmp/ \*.patch
	touch $(NETSNMP_DIR)/.unpacked

ifeq ($(BR2_ENDIAN),"BIG")
NETSNMP_ENDIAN=big
else
NETSNMP_ENDIAN=little
endif

# We set CAN_USE_SYSCTL to no and use /proc since the
# sysctl code in this thing is apparently intended for
# freebsd or some such thing...
$(NETSNMP_DIR)/.configured: $(NETSNMP_DIR)/.unpacked
	(cd $(NETSNMP_DIR); rm -f config.cache; \
		autoconf && \
		ac_cv_CAN_USE_SYSCTL=no \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--with-cc=$(TARGET_CROSS)gcc \
		--with-ar=$(TARGET_CROSS)ar \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--with-endianness=$(NETSNMP_ENDIAN) \
		--with-persistent-directory=/var/lib/snmp \
		--enable-ucd-snmp-compatibility \
		--enable-shared \
		--disable-static \
		--with-logfile=none \
		--without-rpm \
		--with-openssl \
		--without-dmalloc \
		--without-efence \
		--without-rsaref \
		--with-sys-contact="root" \
		--with-sys-location="Unknown" \
		--with-mib-modules="host smux ucd-snmp/dlmod" \
		--with-defaults \
		--prefix=/usr \
		--sysconfdir=/etc \
		--mandir=/usr/man \
		--infodir=/usr/info \
	)
	touch $(NETSNMP_DIR)/.configured

$(NETSNMP_DIR)/agent/snmpd: $(NETSNMP_DIR)/.configured
	$(MAKE1) -C $(NETSNMP_DIR)

$(TARGET_DIR)/usr/sbin/snmpd: $(NETSNMP_DIR)/agent/snmpd
	$(MAKE) PREFIX=$(TARGET_DIR)/usr \
	    prefix=$(TARGET_DIR)/usr \
	    exec_prefix=$(TARGET_DIR)/usr \
	    persistentdir=$(TARGET_DIR)/var/lib/snmp \
	    infodir=$(TARGET_DIR)/usr/info \
	    mandir=$(TARGET_DIR)/usr/man \
	    includedir=$(STAGING_DIR)/usr/include/net-snmp \
	    ucdincludedir=$(STAGING_DIR)/usr/include/ucd-snmp \
	    -C $(NETSNMP_DIR) install
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc
	# Copy the .conf files.
	mkdir -p $(TARGET_DIR)/etc/snmp
	cp $(NETSNMP_DIR)/EXAMPLE.conf $(TARGET_DIR)/etc/snmp/snmpd.conf
	cp $(NETSNMP_DIR)/EXAMPLE-trap.conf $(TARGET_DIR)/etc/snmp/snmptrapd.conf
	-mv $(TARGET_DIR)/usr/share/snmp/mib2c*.conf $(TARGET_DIR)/etc/snmp
	mkdir -p $(TARGET_DIR)/etc/default
	cp $(NETSNMP_DIR)/debian/snmpd.default $(TARGET_DIR)/etc/default/snmpd
	# Remove the unsupported snmpcheck program
	rm $(TARGET_DIR)/usr/bin/snmpcheck
	# Install the "broken" headers
	cp $(NETSNMP_DIR)/agent/mibgroup/struct.h $(STAGING_DIR)/usr/include/net-snmp/agent
	cp $(NETSNMP_DIR)/agent/mibgroup/util_funcs.h $(STAGING_DIR)/usr/include/net-snmp
	cp $(NETSNMP_DIR)/agent/mibgroup/mibincl.h $(STAGING_DIR)/usr/include/net-snmp/library
	cp $(NETSNMP_DIR)/agent/mibgroup/header_complex.h $(STAGING_DIR)/usr/include/net-snmp/agent

netsnmp: openssl $(TARGET_DIR)/usr/sbin/snmpd

netsnmp-headers: $(TARGET_DIR)/usr/include/net-snmp/net-snmp-config.h
	cp -a $(STAGING_DIR)/usr/include/net-snmp $(TARGET_DIR)/usr/include/net-snmp
	cp -a $(STAGING_DIR)/usr/include/ucd-snmp $(TARGET_DIR)/usr/include/net-snmp

netsnmp-source: $(DL_DIR)/$(NETSNMP_SOURCE)

netsnmp-clean:
	-$(MAKE) PREFIX=$(TARGET_DIR) INSTALL_PREFIX=$(TARGET_DIR) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(NETSNMP_DIR) uninstall
	-$(MAKE) -C $(NETSNMP_DIR) clean
	-rm -rf $(TARGET_DIR)/etc/snmp/{snmpd{,trapd},mib2c*}.conf \
		$(TARGET_DIR)/etc/default/snmpd \
		$(TARGET_DIR)/usr/include/net-snmp

netsnmp-dirclean:
	rm -rf $(NETSNMP_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_NETSNMP)),y)
TARGETS+=netsnmp
endif
