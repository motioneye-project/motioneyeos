################################################################################
#
# openvpn
#
################################################################################

OPENVPN_VERSION = 2.3.3
OPENVPN_SOURCE = openvpn-$(OPENVPN_VERSION).tar.xz
OPENVPN_SITE = http://swupdate.openvpn.net/community/releases
OPENVPN_DEPENDENCIES = host-pkgconf
OPENVPN_LICENSE = GPLv2
OPENVPN_LICENSE_FILES = COPYRIGHT.GPL
OPENVPN_CONF_OPT = --disable-plugin-auth-pam --enable-iproute2
OPENVPN_CONF_ENV = IFCONFIG=/sbin/ifconfig \
	NETSTAT=/bin/netstat \
	ROUTE=/sbin/route

ifeq ($(BR2_PACKAGE_OPENVPN_SMALL),y)
OPENVPN_CONF_OPT += --enable-small --disable-plugins \
	--disable-debug --disable-eurephia
endif

# Busybox 1.21+ places the ip applet in the "correct" place
# but previous versions didn't.
ifeq ($(BR2_PACKAGE_IPROUTE2),y)
OPENVPN_CONF_ENV += IPROUTE=/sbin/ip
else ifeq ($(BR2_BUSYBOX_VERSION_1_19_X)$(BR2_BUSYBOX_VERSION_1_20_X),y)
OPENVPN_CONF_ENV += IPROUTE=/bin/ip
else
OPENVPN_CONF_ENV += IPROUTE=/sbin/ip
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
	$(INSTALL) -m 755 -D package/openvpn/S60openvpn \
		$(TARGET_DIR)/etc/init.d/S60openvpn
endef

$(eval $(autotools-package))
