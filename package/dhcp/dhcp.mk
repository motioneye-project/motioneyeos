#############################################################
#
# dhcp
#
#############################################################
DHCP:=dhcp-3.0.1.tar.gz
DHCP_SITE:=ftp://ftp.isc.org/isc/dhcp
DHCP_CAT:=zcat
DHCP_DIR:=$(BUILD_DIR)/dhcp-3.0.1
DHCP_RELAY_BINARY:=work.linux-2.2/relay/dhcrelay
DHCP_SERVER_TARGET_BINARY:=usr/sbin/dhcpd
DHCP_RELAY_TARGET_BINARY:=usr/sbin/dhcrelay
DHCP_CLIENT_TARGET_BINARY:=usr/sbin/dhclient
BVARS=PREDEFINES='-D_PATH_DHCPD_DB=\"/var/lib/dhcp/dhcpd.leases\" \
	-D_PATH_DHCLIENT_DB=\"/var/lib/dhcp/dhclient.leases\"' \
	VARDB=/var/lib/dhcp

$(DL_DIR)/$(DHCP):
	 $(WGET) -P $(DL_DIR) $(DHCP_SITE)/$(DHCP)

dhcp-source: $(DL_DIR)/$(DHCP)

$(DHCP_DIR)/.unpacked: $(DL_DIR)/$(DHCP)
	$(DHCP_CAT) $(DL_DIR)/$(DHCP) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(DHCP_DIR) package/dhcp/ dhcp*.patch
	touch $(DHCP_DIR)/.unpacked

$(DHCP_DIR)/.configured: $(DHCP_DIR)/.unpacked
	(cd $(DHCP_DIR); $(TARGET_CONFIGURE_OPTS) ./configure );
	touch  $(DHCP_DIR)/.configured

$(DHCP_DIR)/$(DHCP_RELAY_BINARY): $(DHCP_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) $(BVARS) -C $(DHCP_DIR)
	$(STRIP) $(DHCP_DIR)/$(DHCP_RELAY_BINARY)

$(TARGET_DIR)/$(DHCP_SERVER_TARGET_BINARY): $(DHCP_DIR)/$(DHCP_RELAY_BINARY)
	(cd $(TARGET_DIR)/var/lib; ln -sf /tmp dhcp)
	$(INSTALL) -m 0755 -D $(DHCP_DIR)/dhcpd $(TARGET_DIR)/$(DHCP_SERVER_TARGET_BINARY)
	$(INSTALL) -m 0755 -D package/dhcp/init-server $(TARGET_DIR)/etc/init.d/S80dhcp-server
	$(INSTALL) -m 0644 -D package/dhcp/dhcpd.conf $(TARGET_DIR)/etc/dhcp/dhcpd.conf
	$(INSTALL) -m 0644 -D package/dhcp/default-server $(TARGET_DIR)/etc/default/dhcp-server
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc

$(TARGET_DIR)/$(DHCP_RELAY_TARGET_BINARY): $(DHCP_DIR)/$(DHCP_RELAY_BINARY)
	(cd $(TARGET_DIR)/var/lib; ln -sf /tmp dhcp)
	$(INSTALL) -m 0755 -D $(DHCP_DIR)/work.linux-2.2/relay/dhcrelay $(TARGET_DIR)/$(DHCP_RELAY_TARGET_BINARY)
	$(INSTALL) -m 0755 -D package/dhcp/init-relay $(TARGET_DIR)/etc/init.d/S80dhcp-relay
	$(INSTALL) -m 0644 -D package/dhcp/default-relay $(TARGET_DIR)/etc/default/dhcp-relay
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc

$(TARGET_DIR)/$(DHCP_CLIENT_TARGET_BINARY): $(DHCP_DIR)/$(DHCP_RELAY_BINARY)
	(cd $(TARGET_DIR)/var/lib; ln -sf /tmp dhcp)
	$(INSTALL) -m 0755 -D $(DHCP_DIR)/dhclient $(TARGET_DIR)/$(DHCP_CLIENT_TARGET_BINARY)
	$(INSTALL) -m 0644 -D $(DHCP_DIR)/dhclient.conf $(TARGET_DIR)/etc/dhcp/dhclient.conf
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc

dhcp_server: uclibc $(TARGET_DIR)/$(DHCP_SERVER_TARGET_BINARY)

dhcp_relay: uclibc $(TARGET_DIR)/$(DHCP_RELAY_TARGET_BINARY)

dhcp_client: uclibc $(TARGET_DIR)/$(DHCP_CLIENT_TARGET_BINARY)

dhcp-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(DHCP_DIR) uninstall
	-$(MAKE) -C $(DHCP_DIR) clean

dhcp-dirclean:
	rm -rf $(DHCP_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_ISC_DHCP)),y)
TARGETS+=dhcp
endif
ifeq ($(strip $(BR2_PACKAGE_DHCP_SERVER)),y)
TARGETS+=dhcp_relay
endif
ifeq ($(strip $(BR2_PACKAGE_DHCP_RELAY)),y)
TARGETS+=dhcp_relay
endif
ifeq ($(strip $(BR2_PACKAGE_DHCP_CLIENT)),y)
TARGETS+=dhcp_relay
endif
