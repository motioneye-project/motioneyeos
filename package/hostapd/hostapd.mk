################################################################################
#
# hostapd
#
################################################################################

HOSTAPD_VERSION = 2.7
HOSTAPD_SITE = http://w1.fi/releases
HOSTAPD_PATCH = \
	https://w1.fi/security/2019-1/0001-OpenSSL-Use-constant-time-operations-for-private-big.patch \
	https://w1.fi/security/2019-1/0002-Add-helper-functions-for-constant-time-operations.patch \
	https://w1.fi/security/2019-1/0003-OpenSSL-Use-constant-time-selection-for-crypto_bignu.patch \
	https://w1.fi/security/2019-2/0004-EAP-pwd-Use-constant-time-and-memory-access-for-find.patch \
	https://w1.fi/security/2019-1/0005-SAE-Minimize-timing-differences-in-PWE-derivation.patch \
	https://w1.fi/security/2019-1/0006-SAE-Avoid-branches-in-is_quadratic_residue_blind.patch \
	https://w1.fi/security/2019-1/0007-SAE-Mask-timing-of-MODP-groups-22-23-24.patch \
	https://w1.fi/security/2019-1/0008-SAE-Use-const_time-selection-for-PWE-in-FFC.patch \
	https://w1.fi/security/2019-1/0009-SAE-Use-constant-time-operations-in-sae_test_pwd_see.patch \
	https://w1.fi/security/2019-3/0010-SAE-Fix-confirm-message-validation-in-error-cases.patch \
	https://w1.fi/security/2019-4/0011-EAP-pwd-server-Verify-received-scalar-and-element.patch \
	https://w1.fi/security/2019-4/0012-EAP-pwd-server-Detect-reflection-attacks.patch \
	https://w1.fi/security/2019-4/0013-EAP-pwd-client-Verify-received-scalar-and-element.patch \
	https://w1.fi/security/2019-4/0014-EAP-pwd-Check-element-x-y-coordinates-explicitly.patch \
	https://w1.fi/security/2019-5/0001-EAP-pwd-server-Fix-reassembly-buffer-handling.patch \
	https://w1.fi/security/2019-5/0003-EAP-pwd-peer-Fix-reassembly-buffer-handling.patch
HOSTAPD_SUBDIR = hostapd
HOSTAPD_CONFIG = $(HOSTAPD_DIR)/$(HOSTAPD_SUBDIR)/.config
HOSTAPD_DEPENDENCIES = host-pkgconf
HOSTAPD_CFLAGS = $(TARGET_CFLAGS)
HOSTAPD_LICENSE = BSD-3-Clause
HOSTAPD_LICENSE_FILES = README
HOSTAPD_CONFIG_SET =

HOSTAPD_CONFIG_ENABLE = CONFIG_INTERNAL_LIBTOMMATH

HOSTAPD_CONFIG_DISABLE =

# Try to use openssl if it's already available
ifeq ($(BR2_PACKAGE_LIBOPENSSL),y)
HOSTAPD_DEPENDENCIES += host-pkgconf libopenssl
HOSTAPD_LIBS += `$(PKG_CONFIG_HOST_BINARY) --libs openssl`
HOSTAPD_CONFIG_EDITS += 's/\#\(CONFIG_TLS=openssl\)/\1/'
else
HOSTAPD_CONFIG_DISABLE += CONFIG_EAP_PWD
HOSTAPD_CONFIG_EDITS += 's/\#\(CONFIG_TLS=\).*/\1internal/'
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_DRIVER_HOSTAP),)
HOSTAPD_CONFIG_DISABLE += CONFIG_DRIVER_HOSTAP
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_DRIVER_NL80211),)
HOSTAPD_CONFIG_DISABLE += CONFIG_DRIVER_NL80211
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_DRIVER_RTW),y)
HOSTAPD_PATCH += https://github.com/pritambaral/hostapd-rtl871xdrv/raw/master/rtlxdrv.patch
HOSTAPD_CONFIG_SET += CONFIG_DRIVER_RTW
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_DRIVER_WIRED),y)
HOSTAPD_CONFIG_ENABLE += CONFIG_DRIVER_WIRED
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_DRIVER_NONE),y)
HOSTAPD_CONFIG_ENABLE += CONFIG_DRIVER_NONE
endif

# Add options for wireless drivers
ifeq ($(BR2_PACKAGE_HOSTAPD_HAS_WIFI_DRIVERS),y)
HOSTAPD_CONFIG_ENABLE += \
	CONFIG_HS20 \
	CONFIG_IEEE80211AC \
	CONFIG_IEEE80211N \
	CONFIG_IEEE80211R \
	CONFIG_INTERWORKING
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_ACS),y)
HOSTAPD_CONFIG_ENABLE += CONFIG_ACS
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_EAP),y)
HOSTAPD_CONFIG_ENABLE += \
	CONFIG_EAP \
	CONFIG_RADIUS_SERVER

# Enable both TLS v1.1 (CONFIG_TLSV11) and v1.2 (CONFIG_TLSV12)
HOSTAPD_CONFIG_ENABLE += CONFIG_TLSV1
else
HOSTAPD_CONFIG_DISABLE += CONFIG_EAP
HOSTAPD_CONFIG_ENABLE += \
	CONFIG_NO_ACCOUNTING \
	CONFIG_NO_RADIUS
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_WPS),y)
HOSTAPD_CONFIG_ENABLE += CONFIG_WPS
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_VLAN),)
HOSTAPD_CONFIG_ENABLE += CONFIG_NO_VLAN
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_VLAN_DYNAMIC),y)
HOSTAPD_CONFIG_ENABLE += CONFIG_FULL_DYNAMIC_VLAN
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_VLAN_NETLINK),y)
HOSTAPD_CONFIG_ENABLE += CONFIG_VLAN_NETLINK
endif

# Options for building with libnl
ifeq ($(BR2_PACKAGE_LIBNL),y)
HOSTAPD_DEPENDENCIES += libnl
HOSTAPD_CFLAGS += -I$(STAGING_DIR)/usr/include/libnl3/
HOSTAPD_CONFIG_ENABLE += CONFIG_LIBNL32
# libnl-3 needs -lm (for rint) and -lpthread if linking statically
# And library order matters hence stick -lnl-3 first since it's appended
# in the hostapd Makefiles as in LIBS+=-lnl-3 ... thus failing
ifeq ($(BR2_STATIC_LIBS),y)
HOSTAPD_LIBS += -lnl-3 -lm -lpthread
endif
endif

define HOSTAPD_CONFIGURE_CMDS
	cp $(@D)/hostapd/defconfig $(HOSTAPD_CONFIG)
	sed -i $(patsubst %,-e 's/^#\(%\)/\1/',$(HOSTAPD_CONFIG_ENABLE)) \
		$(patsubst %,-e 's/^\(%\)/#\1/',$(HOSTAPD_CONFIG_DISABLE)) \
		$(patsubst %,-e '1i%=y',$(HOSTAPD_CONFIG_SET)) \
		$(patsubst %,-e %,$(HOSTAPD_CONFIG_EDITS)) \
		$(HOSTAPD_CONFIG)
endef

define HOSTAPD_BUILD_CMDS
	$(TARGET_MAKE_ENV) CFLAGS="$(HOSTAPD_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" LIBS="$(HOSTAPD_LIBS)" \
		$(MAKE) CC="$(TARGET_CC)" -C $(@D)/$(HOSTAPD_SUBDIR)
endef

define HOSTAPD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/$(HOSTAPD_SUBDIR)/hostapd \
		$(TARGET_DIR)/usr/sbin/hostapd
	$(INSTALL) -m 0755 -D $(@D)/$(HOSTAPD_SUBDIR)/hostapd_cli \
		$(TARGET_DIR)/usr/bin/hostapd_cli
	$(INSTALL) -m 0644 -D $(@D)/$(HOSTAPD_SUBDIR)/hostapd.conf \
		$(TARGET_DIR)/etc/hostapd.conf
endef

$(eval $(generic-package))
