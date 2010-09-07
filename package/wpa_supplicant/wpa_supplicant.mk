#############################################################
#
# wpa_supplicant
#
#############################################################

WPA_SUPPLICANT_VERSION = 0.6.10
WPA_SUPPLICANT_SITE = http://hostap.epitest.fi/releases
WPA_SUPPLICANT_LIBTOOL_PATCH = NO
WPA_SUPPLICANT_DEPENDENCIES =
WPA_SUPPLICANT_CONFIG = $(WPA_SUPPLICANT_DIR)/wpa_supplicant/.config
WPA_SUPPLICANT_SUBDIR = wpa_supplicant
WPA_SUPPLICANT_TARGET_BINS = wpa_cli wpa_supplicant wpa_passphrase
WPA_SUPPLICANT_DBUS_SERVICE = fi.epitest.hostap.WPASupplicant

ifeq ($(BR2_PACKAGE_LIBNL),y)
	WPA_SUPPLICANT_DEPENDENCIES += libnl
define WPA_SUPPLICANT_LIBNL_CONFIG
	echo "CONFIG_DRIVER_NL80211=y" >>$(WPA_SUPPLICANT_CONFIG)
endef
endif

ifneq ($(BR2_PACKAGE_WPA_SUPPLICANT_EAP),y)
define WPA_SUPPLICANT_CRYPTO_CONFIG
	$(SED) "s/^CONFIG_EAP_*/#CONFIG_EAP_/g" $(WPA_SUPPLICANT_CONFIG)
	echo "CONFIG_TLS=none" >>$(WPA_SUPPLICANT_CONFIG)
endef
else
ifeq ($(BR2_PACKAGE_WPA_SUPPLICANT_OPENSSL),y)
	WPA_SUPPLICANT_DEPENDENCIES += openssl
define WPA_SUPPLICANT_CRYPTO_CONFIG
	echo "CONFIG_TLS=openssl" >>$(WPA_SUPPLICANT_CONFIG)
endef
else
define WPA_SUPPLICANT_CRYPTO_CONFIG
	echo "CONFIG_TLS=internal" >>$(WPA_SUPPLICANT_CONFIG)
	echo "CONFIG_INTERNAL_LIBTOMMATH=y" >>$(WPA_SUPPLICANT_CONFIG)
endef
endif
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
	WPA_SUPPLICANT_DEPENDENCIES += host-pkg-config dbus
	WPA_SUPPLICANT_MAKE_ENV = \
		PKG_CONFIG_SYSROOT_DIR="$(STAGING_DIR)"	\
		PKG_CONFIG_PATH="$(STAGING_DIR)/usr/lib/pkgconfig"
define WPA_SUPPLICANT_DBUS_CONFIG
	echo "CONFIG_CTRL_IFACE_DBUS=y" >>$(WPA_SUPPLICANT_CONFIG)
endef
endif

define WPA_SUPPLICANT_CONFIGURE_CMDS
	cp $(@D)/wpa_supplicant/defconfig $(WPA_SUPPLICANT_CONFIG)
	echo "CFLAGS += $(TARGET_CFLAGS)" >>$(WPA_SUPPLICANT_CONFIG)
	echo "LDFLAGS += $(TARGET_LDFLAGS)" >>$(WPA_SUPPLICANT_CONFIG)
	echo "CC = $(TARGET_CC)" >>$(WPA_SUPPLICANT_CONFIG)
	$(SED) "s/\/local//" $(@D)/wpa_supplicant/Makefile
	$(WPA_SUPPLICANT_CRYPTO_CONFIG)
	$(WPA_SUPPLICANT_LIBNL_CONFIG)
	$(WPA_SUPPLICANT_DBUS_CONFIG)
endef

define WPA_SUPPLICANT_REMOVE_CLI
	rm -f $(TARGET_DIR)/usr/sbin/wpa_cli
endef

ifneq ($(BR2_PACKAGE_WPA_SUPPLICANT_CLI),y)
WPA_SUPPLICANT_POST_INSTALL_TARGET_HOOKS += WPA_SUPPLICANT_REMOVE_CLI
endif

define WPA_SUPPLICANT_REMOVE_PASSPHRASE
	rm -f $(TARGET_DIR)/usr/sbin/wpa_passphrase
endef

ifneq ($(BR2_PACKAGE_WPA_SUPPLICANT_PASSPHRASE),y)
WPA_SUPPLICANT_POST_INSTALL_TARGET_HOOKS += WPA_SUPPLICANT_REMOVE_PASSPHRASE
endif

define WPA_SUPPLICANT_INSTALL_DBUS
	$(INSTALL) -D \
	  $(@D)/wpa_supplicant/dbus-wpa_supplicant.conf \
	  $(TARGET_DIR)/etc/dbus-1/system.d/wpa_supplicant.conf
	$(INSTALL) -D \
	  $(@D)/wpa_supplicant/dbus-wpa_supplicant.service \
	  $(TARGET_DIR)/usr/share/dbus-1/system-services/$(WPA_SUPPLICANT_DBUS_SERVICE).service
endef

ifeq ($(BR2_PACKAGE_DBUS),y)
WPA_SUPPLICANT_POST_INSTALL_TARGET_HOOKS += WPA_SUPPLICANT_INSTALL_DBUS
endif

define WPA_SUPPLICANT_UNINSTALL_TARGET_CMDS
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/, $(WPA_SUPPLICANT_TARGET_BINS))
	rm -f $(TARGET_DIR)/etc/dbus-1/system.d/wpa_supplicant.conf
	rm -f $(TARGET_DIR)/usr/share/dbus-1/system-services/$(WPA_SUPPLICANT_DBUS_SERVICE).service
endef

$(eval $(call AUTOTARGETS,package,wpa_supplicant))
