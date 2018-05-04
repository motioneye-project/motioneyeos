################################################################################
#
# openvpn
#
################################################################################

OPENVPN_VERSION = 2.4.6
OPENVPN_SOURCE = openvpn-$(OPENVPN_VERSION).tar.xz
OPENVPN_SITE = http://swupdate.openvpn.net/community/releases
OPENVPN_DEPENDENCIES = host-pkgconf openssl
OPENVPN_LICENSE = GPL-2.0
OPENVPN_LICENSE_FILES = COPYRIGHT.GPL
OPENVPN_CONF_OPTS = \
	--disable-plugin-auth-pam \
	--enable-iproute2 \
	--with-crypto-library=openssl \
	$(if $(BR2_STATIC_LIBS),--disable-plugins)
OPENVPN_CONF_ENV = IFCONFIG=/sbin/ifconfig \
	NETSTAT=/bin/netstat \
	ROUTE=/sbin/route \
	IPROUTE=/sbin/ip

ifeq ($(BR2_PACKAGE_OPENVPN_SMALL),y)
OPENVPN_CONF_OPTS += \
	--enable-small \
	--disable-plugins
endif

ifeq ($(BR2_PACKAGE_OPENVPN_LZ4),y)
OPENVPN_DEPENDENCIES += lz4
else
OPENVPN_CONF_OPTS += --disable-lz4
endif

ifeq ($(BR2_PACKAGE_OPENVPN_LZO),y)
OPENVPN_DEPENDENCIES += lzo
else
OPENVPN_CONF_OPTS += --disable-lzo
endif

define OPENVPN_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/src/openvpn/openvpn \
		$(TARGET_DIR)/usr/sbin/openvpn
endef

define OPENVPN_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/openvpn/S60openvpn \
		$(TARGET_DIR)/etc/init.d/S60openvpn
endef

$(eval $(autotools-package))
