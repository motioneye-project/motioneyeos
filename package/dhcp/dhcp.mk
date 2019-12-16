################################################################################
#
# dhcp
#
################################################################################

DHCP_VERSION = 4.4.1
DHCP_SITE = http://ftp.isc.org/isc/dhcp/$(DHCP_VERSION)
DHCP_INSTALL_STAGING = YES
DHCP_LICENSE = MPL-2.0
DHCP_LICENSE_FILES = LICENSE
DHCP_DEPENDENCIES = bind

# use libtool-enabled configure.ac
define DHCP_LIBTOOL_AUTORECONF
	cp $(@D)/configure.ac+lt $(@D)/configure.ac
endef

DHCP_CONF_ENV = \
	CPPFLAGS='-D_PATH_DHCPD_CONF=\"/etc/dhcp/dhcpd.conf\" \
		-D_PATH_DHCLIENT_CONF=\"/etc/dhcp/dhclient.conf\"' \
	CFLAGS='$(TARGET_CFLAGS) -DISC_CHECK_NONE=1'

DHCP_CONF_OPTS = \
	--with-libbind=$(STAGING_DIR)/usr \
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

ifeq ($(BR2_STATIC_LIBS),y)
DHCP_CONF_ENV += LIBS="`$(STAGING_DIR)/usr/bin/bind9-config --libs bind9`"
DHCP_CONF_OPTS += --disable-libtool
else
DHCP_POST_EXTRACT_HOOKS += DHCP_LIBTOOL_AUTORECONF
DHCP_AUTORECONF = YES
DHCP_CONF_OPTS += --enable-libtool
endif

ifeq ($(BR2_PACKAGE_DHCP_SERVER_DELAYED_ACK),y)
DHCP_CONF_OPTS += --enable-delayed-ack
endif

define DHCP_INSTALL_LIBS
	$(MAKE) -C $(@D)/common install-exec DESTDIR=$(TARGET_DIR)
	$(MAKE) -C $(@D)/omapip install-exec DESTDIR=$(TARGET_DIR)
endef

ifeq ($(BR2_PACKAGE_DHCP_SERVER),y)
define DHCP_INSTALL_CTL_LIBS
	$(MAKE) -C $(@D)/dhcpctl install-exec DESTDIR=$(TARGET_DIR)
endef
define DHCP_INSTALL_SERVER
	mkdir -p $(TARGET_DIR)/var/lib
	(cd $(TARGET_DIR)/var/lib; ln -snf /tmp dhcp)
	$(MAKE) -C $(@D)/server DESTDIR=$(TARGET_DIR) install-sbinPROGRAMS
	$(INSTALL) -m 0644 -D package/dhcp/dhcpd.conf \
		$(TARGET_DIR)/etc/dhcp/dhcpd.conf
endef
endif

ifeq ($(BR2_PACKAGE_DHCP_RELAY),y)
define DHCP_INSTALL_RELAY
	mkdir -p $(TARGET_DIR)/var/lib
	(cd $(TARGET_DIR)/var/lib; ln -snf /tmp dhcp)
	$(MAKE) -C $(@D)/relay DESTDIR=$(TARGET_DIR) install-sbinPROGRAMS
endef
endif

ifeq ($(BR2_PACKAGE_DHCP_CLIENT),y)
define DHCP_INSTALL_CLIENT
	mkdir -p $(TARGET_DIR)/var/lib
	(cd $(TARGET_DIR)/var/lib; ln -snf /tmp dhcp)
	$(MAKE) -C $(@D)/client DESTDIR=$(TARGET_DIR) sbindir=/sbin \
		install-sbinPROGRAMS
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

	mkdir -p $(TARGET_DIR)/usr/lib/tmpfiles.d
	echo "d /var/lib/dhcp 0755 - - - -" > \
		$(TARGET_DIR)/usr/lib/tmpfiles.d/dhcpd.conf
	echo "f /var/lib/dhcp/dhcpd.leases - - - - -" >> \
		$(TARGET_DIR)/usr/lib/tmpfiles.d/dhcpd.conf
endef
endif

define DHCP_INSTALL_TARGET_CMDS
	$(DHCP_INSTALL_LIBS)
	$(DHCP_INSTALL_CTL_LIBS)
	$(DHCP_INSTALL_RELAY)
	$(DHCP_INSTALL_SERVER)
	$(DHCP_INSTALL_CLIENT)
endef

$(eval $(autotools-package))
