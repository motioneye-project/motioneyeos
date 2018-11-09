################################################################################
#
# dhcp
#
################################################################################

DHCP_VERSION = 4.3.6
DHCP_SITE = http://ftp.isc.org/isc/dhcp/$(DHCP_VERSION)
DHCP_INSTALL_STAGING = YES
DHCP_LICENSE = ISC
DHCP_LICENSE_FILES = LICENSE
DHCP_CONF_ENV = \
	CPPFLAGS='-D_PATH_DHCPD_CONF=\"/etc/dhcp/dhcpd.conf\" \
		-D_PATH_DHCLIENT_CONF=\"/etc/dhcp/dhclient.conf\"' \
	CFLAGS='$(TARGET_CFLAGS) -DISC_CHECK_NONE=1'

DHCP_CONF_OPTS = \
	--with-randomdev=/dev/random \
	--with-srv-lease-file=/var/lib/dhcp/dhcpd.leases \
	--with-srv6-lease-file=/var/lib/dhcp/dhcpd6.leases \
	--with-cli-lease-file=/var/lib/dhcp/dhclient.leases \
	--with-cli6-lease-file=/var/lib/dhcp/dhclient6.leases \
	--with-srv-pid-file=/var/run/dhcpd.pid \
	--with-srv6-pid-file=/var/run/dhcpd6.pid \
	--with-cli-pid-file=/var/run/dhclient.pid \
	--with-cli6-pid-file=/var/run/dhclient6.pid \
	--with-relay-pid-file=/var/run/dhcrelay.pid \
	--with-relay6-pid-file=/var/run/dhcrelay6.pid

# The source for the bind libraries used by dhcp are embedded in the dhcp source
# as a tar-ball. Extract the bind source to allow any patches to be applied
# during the patch phase.
define DHCP_EXTRACT_BIND
	cd $(@D)/bind; tar -xvf bind.tar.gz
endef
DHCP_POST_EXTRACT_HOOKS += DHCP_EXTRACT_BIND

# The patchset requires configure et.al. to be regenerated.
DHCP_AUTORECONF = YES

# bind does not support parallel builds.
DHCP_MAKE = $(MAKE1)

# bind configure is called via dhcp make instead of dhcp configure. The make env
# needs extra values for bind configure.
DHCP_MAKE_ENV = \
	$(TARGET_CONFIGURE_OPTS) \
	BUILD_CC="$(HOSTCC)" \
	BUILD_CFLAGS="$(HOST_CFLAGS)" \
	BUILD_CPPFLAGS="$(HOST_CPPFLAGS)" \
	BUILD_LDFLAGS="$(HOST_LDFLAGS)"

ifeq ($(BR2_PACKAGE_DHCP_SERVER_DELAYED_ACK),y)
DHCP_CONF_OPTS += --enable-delayed-ack
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
		$(TARGET_DIR)/sbin/dhclient
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

ifeq ($(BR2_PACKAGE_DHCP_SERVER),y)
define DHCP_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/dhcp/dhcpd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/dhcpd.service

	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants

	ln -sf ../../../../usr/lib/systemd/system/dhcpd.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/dhcpd.service

	mkdir -p $(TARGET_DIR)/usr/lib/tmpfiles.d
	echo "d /var/lib/dhcp 0755 - - - -" > \
		$(TARGET_DIR)/usr/lib/tmpfiles.d/dhcpd.conf
	echo "f /var/lib/dhcp/dhcpd.leases - - - - -" >> \
		$(TARGET_DIR)/usr/lib/tmpfiles.d/dhcpd.conf
endef
endif

define DHCP_INSTALL_TARGET_CMDS
	$(DHCP_INSTALL_RELAY)
	$(DHCP_INSTALL_SERVER)
	$(DHCP_INSTALL_CLIENT)
endef

$(eval $(autotools-package))
