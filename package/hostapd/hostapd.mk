#############################################################
#
# hostapd
#
#############################################################

HOSTAPD_VERSION = 0.6.9
HOSTAPD_SITE = http://hostap.epitest.fi/releases
HOSTAPD_SUBDIR = hostapd
HOSTAPD_CONFIG = $(HOSTAPD_DIR)/$(HOSTAPD_SUBDIR)/.config

ifeq ($(BR2_PACKAGE_LIBNL),y)
	HOSTAPD_DEPENDENCIES += libnl
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
	HOSTAPD_DEPENDENCIES += openssl
endif

$(eval $(call AUTOTARGETS,package,hostapd))

$(HOSTAPD_TARGET_CONFIGURE):
	cp $(HOSTAPD_DIR)/$(HOSTAPD_SUBDIR)/defconfig $(HOSTAPD_CONFIG)
	$(SED) "s/\/local//" $(HOSTAPD_DIR)/$(HOSTAPD_SUBDIR)/Makefile
	echo "CFLAGS += $(TARGET_CFLAGS)" >>$(HOSTAPD_CONFIG)
	echo "CC = $(TARGET_CC)" >>$(HOSTAPD_CONFIG)
# IPv6
ifneq ($(BR2_INET_IPV6),y)
	$(SED) "s/CONFIG_IPV6=y//" $(HOSTAPD_CONFIG)
endif
# EAP
	echo "CONFIG_EAP_AKA=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_AKA_PRIME=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_GPSK=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_GPSK_SHA256=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_PAX=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_PSK=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_SAKE=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_SIM=y" >>$(HOSTAPD_CONFIG)
ifneq ($(BR2_PACKAGE_HOSTAPD_EXTRA_EAP),y)
	$(SED) "s/CONFIG_EAP_MSCHAPV2=y//" $(HOSTAPD_CONFIG)
	$(SED) "s/CONFIG_EAP_PEAP=y//" $(HOSTAPD_CONFIG)
	$(SED) "s/CONFIG_EAP_TLS=y//" $(HOSTAPD_CONFIG)
	$(SED) "s/CONFIG_EAP_TTLS=y//" $(HOSTAPD_CONFIG)
endif
# OpenSSL is required for EXTRA_EAP and/or WPS
# We take care of that in Config.in
ifneq ($(BR2_PACKAGE_OPENSSL),y)
	echo "CONFIG_CRYPTO=internal" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_TLS=internal" >>$(HOSTAPD_CONFIG)
endif
# WPS
ifeq ($(BR2_PACKAGE_HOSTAPD_WPS),y)
	echo "CONFIG_WPS=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_WPS_UPNP=y" >>$(HOSTAPD_CONFIG)
endif
# Drivers
	echo "CONFIG_DRIVER_WIRED=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_DRIVER_PRISM54=y" >>$(HOSTAPD_CONFIG)
ifeq ($(BR2_PACKAGE_LIBNL),y)
	echo "CONFIG_DRIVER_NL80211=y" >>$(HOSTAPD_CONFIG)
endif
# Misc
	echo "CONFIG_IEEE80211N=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_IEEE80211R=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_IEEE80211W=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_RADIUS_SERVER=y" >>$(HOSTAPD_CONFIG)
	touch $@

$(HOSTAPD_TARGET_INSTALL_TARGET):
	$(call MESSAGE,"Installing to target")
	$(INSTALL) -m 0755 $(HOSTAPD_DIR)/$(HOSTAPD_SUBDIR)/hostapd \
		$(TARGET_DIR)/usr/sbin
	$(INSTALL) -m 0755 $(HOSTAPD_DIR)/$(HOSTAPD_SUBDIR)/hostapd_cli \
		$(TARGET_DIR)/usr/bin
	touch $@

$(HOSTAPD_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(TARGET_DIR)/usr/sbin/hostapd
	rm -f $(TARGET_DIR)/usr/bin/hostapd
	rm -f $(HOSTAPD_TARGET_INSTALL_TARGET) $(HOSTAPD_HOOK_POST_INSTALL)

