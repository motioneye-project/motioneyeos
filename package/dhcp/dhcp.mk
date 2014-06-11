################################################################################
#
# dhcp
#
################################################################################

DHCP_VERSION = 4.1-ESV-R9
DHCP_SITE = http://ftp.isc.org/isc/dhcp/$(DHCP_VERSION)
DHCP_INSTALL_STAGING = YES
DHCP_LICENSE = ISC
DHCP_LICENSE_FILES = LICENSE
DHCP_CONF_ENV = ac_cv_file__dev_random=yes
DHCP_CONF_OPT = \
	--localstatedir=/var/lib/dhcp \
	--with-srv-lease-file=/var/lib/dhcp/dhcpd.leases \
	--with-cli-lease-file=/var/lib/dhcp/dhclient.leases \
	--with-srv-pid-file=/var/run/dhcpd.pid \
	--with-cli-pid-file=/var/run/dhclient.pid \
	--with-relay-pid-file=/var/run/dhcrelay.pid

ifeq ($(BR2_PACKAGE_DHCP_SERVER_DELAYED_ACK),y)
        DHCP_CONF_OPT += --enable-delayed-ack
endif

ifneq ($(BR2_INET_IPV6),y)
        DHCP_CONF_OPT += --disable-dhcpv6
endif

ifeq ($(BR2_PACKAGE_DHCP_SERVER),y)
define DHCP_INSTALL_SERVER
	mkdir -p $(TARGET_DIR)/var/lib
	(cd $(TARGET_DIR)/var/lib; ln -snf /tmp dhcp)
	$(INSTALL) -m 0755 -D $(@D)/server/dhcpd $(TARGET_DIR)/usr/sbin/dhcpd
	$(INSTALL) -m 0644 -D package/dhcp/dhcpd.conf \
		$(TARGET_DIR)/etc/dhcp/dhcpd.conf
endef
endif

ifeq ($(BR2_PACKAGE_DHCP_RELAY),y)
define DHCP_INSTALL_RELAY
	mkdir -p $(TARGET_DIR)/var/lib
	(cd $(TARGET_DIR)/var/lib; ln -snf /tmp dhcp)
	$(INSTALL) -m 0755 -D $(DHCP_DIR)/relay/dhcrelay \
		$(TARGET_DIR)/usr/sbin/dhcrelay
endef
endif

ifeq ($(BR2_PACKAGE_DHCP_CLIENT),y)
define DHCP_INSTALL_CLIENT
	mkdir -p $(TARGET_DIR)/var/lib
	(cd $(TARGET_DIR)/var/lib; ln -snf /tmp dhcp)
	$(INSTALL) -m 0755 -D $(DHCP_DIR)/client/dhclient \
		$(TARGET_DIR)/usr/sbin/dhclient
	$(INSTALL) -m 0644 -D package/dhcp/dhclient.conf \
		$(TARGET_DIR)/etc/dhcp/dhclient.conf
	$(INSTALL) -m 0755 -D package/dhcp/dhclient-script \
		$(TARGET_DIR)/sbin/dhclient-script
endef
endif

# Options don't matter, scripts won't start if binaries aren't there
define DHCP_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/dhcp/S80dhcp-server \
		$(TARGET_DIR)/etc/init.d/S80dhcp-server
	$(INSTALL) -m 0755 -D package/dhcp/S80dhcp-relay \
		$(TARGET_DIR)/etc/init.d/S80dhcp-relay
endef

define DHCP_INSTALL_TARGET_CMDS
	$(DHCP_INSTALL_RELAY)
	$(DHCP_INSTALL_SERVER)
	$(DHCP_INSTALL_CLIENT)
endef

$(eval $(autotools-package))
