#############################################################
#
# openvpn
#
#############################################################

OPENVPN_VERSION = 2.3.0
OPENVPN_SITE = http://swupdate.openvpn.net/community/releases
OPENVPN_DEPENDENCIES = host-pkgconf
OPENVPN_CONF_OPT = --disable-plugin-auth-pam --enable-iproute2
OPENVPN_CONF_ENV = IFCONFIG=/sbin/ifconfig \
	NETSTAT=/bin/netstat \
	ROUTE=/sbin/route

ifeq ($(BR2_PACKAGE_OPENVPN_SMALL),y)
OPENVPN_CONF_OPT += --enable-small --disable-plugins \
	--disable-debug --disable-eurephia
endif

ifeq ($(BR2_PACKAGE_IPROUTE2),y)
OPENVPN_CONF_ENV += IPROUTE=/sbin/ip
else
OPENVPN_CONF_ENV += IPROUTE=/bin/ip
endif

ifeq ($(BR2_PACKAGE_OPENVPN_LZO),y)
	OPENVPN_DEPENDENCIES += lzo
else
	OPENVPN_CONF_OPT += --disable-lzo
endif

ifeq ($(BR2_PACKAGE_OPENVPN_CRYPTO_OPENSSL),y)
	OPENVPN_CONF_OPT += --with-crypto-library=openssl
	OPENVPN_DEPENDENCIES += openssl
endif

ifeq ($(BR2_PACKAGE_OPENVPN_CRYPTO_POLARSSL),y)
	OPENVPN_CONF_OPT += --with-crypto-library=polarssl
	OPENVPN_DEPENDENCIES += polarssl
endif

define OPENVPN_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/src/openvpn/openvpn \
		$(TARGET_DIR)/usr/sbin/openvpn
	if [ ! -f $(TARGET_DIR)/etc/init.d/openvpn ]; then \
		$(INSTALL) -m 755 -D package/openvpn/openvpn.init \
			$(TARGET_DIR)/etc/init.d/openvpn; \
	fi
endef

define OPENVPN_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/sbin/openvpn
	rm -f $(TARGET_DIR)/etc/init.d/openvpn
endef

$(eval $(autotools-package))
