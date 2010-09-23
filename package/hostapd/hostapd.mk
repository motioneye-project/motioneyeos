#############################################################
#
# hostapd
#
#############################################################

HOSTAPD_VERSION = 0.7.2
HOSTAPD_SITE = http://hostap.epitest.fi/releases
HOSTAPD_SUBDIR = hostapd
HOSTAPD_CONFIG = $(HOSTAPD_DIR)/$(HOSTAPD_SUBDIR)/.config
HOSTAPD_DEPENDENCIES = libnl

ifeq ($(BR2_PACKAGE_OPENSSL),y)
	HOSTAPD_DEPENDENCIES += openssl
	# OpenSSL is required for EXTRA_EAP and/or WPS
	# We take care of that in Config.in
else
define HOSTAPD_OPENSSL_CONF
	echo "CONFIG_CRYPTO=internal" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_INTERNAL_LIBTOMMATH=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_TLS=internal" >>$(HOSTAPD_CONFIG)
endef
endif

ifneq ($(BR2_INET_IPV6),y)
define HOSTAPD_IPV6_CONF
	$(SED) "s/CONFIG_IPV6=y//" $(HOSTAPD_CONFIG)
endef
endif

ifneq ($(BR2_PACKAGE_HOSTAPD_EXTRA_EAP),y)
define HOSTAPD_EXTRA_EAP_CONF
	$(SED) "s/CONFIG_EAP_MSCHAPV2=y//" $(HOSTAPD_CONFIG)
	$(SED) "s/CONFIG_EAP_PEAP=y//" $(HOSTAPD_CONFIG)
	$(SED) "s/CONFIG_EAP_TLS=y//" $(HOSTAPD_CONFIG)
	$(SED) "s/CONFIG_EAP_TTLS=y//" $(HOSTAPD_CONFIG)
endef
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_WPS),y)
define HOSTAPD_WPS_CONF
	echo "CONFIG_WPS=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_WPS_UPNP=y" >>$(HOSTAPD_CONFIG)
endef
endif

define HOSTAPD_CONFIGURE_CMDS
	cp $(@D)/$(HOSTAPD_SUBDIR)/defconfig $(HOSTAPD_CONFIG)
	$(SED) "s/\/local//" $(@D)/$(HOSTAPD_SUBDIR)/Makefile
	echo "CFLAGS += $(TARGET_CFLAGS)" >>$(HOSTAPD_CONFIG)
	echo "LDFLAGS += $(TARGET_LDFLAGS)" >>$(HOSTAPD_CONFIG)
	echo "CC = $(TARGET_CC)" >>$(HOSTAPD_CONFIG)
# EAP
	echo "CONFIG_EAP_AKA=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_AKA_PRIME=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_GPSK=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_GPSK_SHA256=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_PAX=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_PSK=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_SAKE=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_SIM=y" >>$(HOSTAPD_CONFIG)
# Drivers
	echo "CONFIG_DRIVER_WIRED=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_DRIVER_PRISM54=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_DRIVER_NL80211=y" >>$(HOSTAPD_CONFIG)
# Misc
	echo "CONFIG_IEEE80211N=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_IEEE80211R=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_IEEE80211W=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_RADIUS_SERVER=y" >>$(HOSTAPD_CONFIG)
	$(HOSTAPD_OPENSSL_CONF)
	$(HOSTAPD_IPV6_CONF)
	$(HOSTAPD_EXTRA_EAP_CONF)
	$(HOSTAPD_WPS_CONF)
endef

define HOSTAPD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/$(HOSTAPD_SUBDIR)/hostapd \
		$(TARGET_DIR)/usr/sbin
	$(INSTALL) -m 0755 $(@D)/$(HOSTAPD_SUBDIR)/hostapd_cli \
		$(TARGET_DIR)/usr/bin
endef

define HOSTAPD_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/sbin/hostapd
	rm -f $(TARGET_DIR)/usr/bin/hostapd
endef

$(eval $(call AUTOTARGETS,package,hostapd))
