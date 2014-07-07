################################################################################
#
# quagga
#
################################################################################

QUAGGA_VERSION = 0.99.23
QUAGGA_SOURCE = quagga-$(QUAGGA_VERSION).tar.xz
QUAGGA_SITE = http://download.savannah.gnu.org/releases/quagga
QUAGGA_DEPENDENCIES = host-gawk
QUAGGA_LICENSE = GPLv2+
QUAGGA_LICENSE_FILES = COPYING
QUAGGA_CONF_OPT = --program-transform-name='' --enable-netlink

QUAGGA_CONF_OPT += $(if $(BR2_PACKAGE_QUAGGA_ZEBRA),--enable-zebra,--disable-zebra)
QUAGGA_CONF_OPT += $(if $(BR2_PACKAGE_QUAGGA_BABELD),--enable-babeld,--disable-babeld)
QUAGGA_CONF_OPT += $(if $(BR2_PACKAGE_QUAGGA_BGPD),--enable-bgpd,--disable-bgpd)
QUAGGA_CONF_OPT += $(if $(BR2_PACKAGE_QUAGGA_RIPD),--enable-ripd,--disable-ripd)
QUAGGA_CONF_OPT += $(if $(BR2_PACKAGE_QUAGGA_RIPNGD),--enable-ripngd,--disable-ripngd)
QUAGGA_CONF_OPT += $(if $(BR2_PACKAGE_QUAGGA_OSPFD),--enable-ospfd,--disable-ospfd)
QUAGGA_CONF_OPT += $(if $(BR2_PACKAGE_QUAGGA_OSPF6D),--enable-ospf6d,--disable-ospf6d)
QUAGGA_CONF_OPT += $(if $(BR2_PACKAGE_QUAGGA_WATCHQUAGGA),--enable-watchquagga,--disable-watchquagga)
QUAGGA_CONF_OPT += $(if $(BR2_PACKAGE_QUAGGA_ISISD),--enable-isisd,--disable-isisd)
QUAGGA_CONF_OPT += $(if $(BR2_PACKAGE_QUAGGA_BGP_ANNOUNCE),--enable-bgp-announce,--disable-bgp-announce)
QUAGGA_CONF_OPT += $(if $(BR2_PACKAGE_QUAGGA_TCP_ZERBRA),--enable-tcp-zebra,--disable-tcp-zebra)
QUAGGA_CONF_OPT += $(if $(BR2_PACKAGE_QUAGGA_OPAQUE_LSA),--enable-opaque-lsa,--disable-opaque-lsa)

ifeq ($(BR2_PACKAGE_QUAGGA_SNMP),y)
QUAGGA_CONF_ENV += ac_cv_path_NETSNMP_CONFIG=$(STAGING_DIR)/usr/bin/net-snmp-config
QUAGGA_CONF_OPT += --enable-snmp=agentx
QUAGGA_DEPENDENCIES += netsnmp
endif

$(eval $(autotools-package))
