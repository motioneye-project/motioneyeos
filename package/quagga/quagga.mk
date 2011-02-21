#############################################################
#
# quagga suite
#
#############################################################
QUAGGA_VERSION:=0.99.17
QUAGGA_SOURCE:=quagga-$(QUAGGA_VERSION).tar.gz
QUAGGA_SITE:=http://www.quagga.net/download/

QUAGGA_DEPENDENCIES = host-gawk
QUAGGA_CONF_OPT = --program-transform-name='' --enable-netlink

ifeq ($(BR2_PACKAGE_QUAGGA_ZEBRA),y)
QUAGGA_CONF_OPT+=--enable-zebra
else
QUAGGA_CONF_OPT+=--disable-zebra
endif

ifeq ($(BR2_PACKAGE_QUAGGA_BGPD),y)
QUAGGA_CONF_OPT+=--enable-bgpd
else
QUAGGA_CONF_OPT+=--disable-bgpd
endif

ifeq ($(BR2_PACKAGE_QUAGGA_RIPD),y)
QUAGGA_CONF_OPT+=--enable-ripd
else
QUAGGA_CONF_OPT+=--disable-ripd
endif

ifeq ($(BR2_PACKAGE_QUAGGA_RIPNGD),y)
QUAGGA_CONF_OPT+=--enable-ripngd
else
QUAGGA_CONF_OPT+=--disable-ripngd
endif

ifeq ($(BR2_PACKAGE_QUAGGA_OSPFD),y)
QUAGGA_CONF_OPT+=--enable-ospfd
else
QUAGGA_CONF_OPT+=--disable-ospfd
endif

ifeq ($(BR2_PACKAGE_QUAGGA_OSPF6D),y)
QUAGGA_CONF_OPT+=--enable-ospf6d
else
QUAGGA_CONF_OPT+=--disable-ospf6d
endif

ifeq ($(BR2_PACKAGE_QUAGGA_WATCHQUAGGA),y)
QUAGGA_CONF_OPT+=--enable-watchquagga
else
QUAGGA_CONF_OPT+=--disable-watchquagga
endif

ifeq ($(BR2_PACKAGE_QUAGGA_ISISD),y)
QUAGGA_CONF_OPT+=--enable-isisd
else
QUAGGA_CONF_OPT+=--disable-isisd
endif

ifeq ($(BR2_PACKAGE_QUAGGA_BGP_ANNOUNCE),y)
QUAGGA_CONF_OPT+=--enable-bgp-announce
else
QUAGGA_CONF_OPT+=--disable-bgp-announce
endif

ifeq ($(BR2_PACKAGE_QUAGGA_SNMP),y)
QUAGGA_CONF_OPT+=--enable-snmp
QUAGGA_DEPENDENCIES+=netsnmp
# SNMP support tries -lcrypto by default, disable it if we ain't got openssl
ifneq ($(BR2_PACKAGE_OPENSSL),y)
QUAGGA_CONF_OPT+=--without-crypto
endif
else
QUAGGA_CONF_OPT+=--disable-snmp
endif

ifeq ($(BR2_PACKAGE_QUAGGA_TCP_ZEBRA),y)
QUAGGA_CONF_OPT+=--enable-tcp-zebra
else
QUAGGA_CONF_OPT+=--disable-tcp-zebra
endif

ifeq ($(BR2_PACKAGE_QUAGGA_OPAQUE_LSA),y)
QUAGGA_CONF_OPT+=--enable-opaque-lsa
else
QUAGGA_CONF_OPT+=--disable-opaque-lsa
endif

$(eval $(call AUTOTARGETS,package,quagga))
