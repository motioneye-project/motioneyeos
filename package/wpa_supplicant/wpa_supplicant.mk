################################################################################
#
# wpa_supplicant
#
################################################################################

WPA_SUPPLICANT_VERSION = 2.1
WPA_SUPPLICANT_SITE = http://hostap.epitest.fi/releases
WPA_SUPPLICANT_LICENSE = GPLv2/BSD-3c
WPA_SUPPLICANT_LICENSE_FILES = README
WPA_SUPPLICANT_CONFIG = $(WPA_SUPPLICANT_DIR)/wpa_supplicant/.config
WPA_SUPPLICANT_SUBDIR = wpa_supplicant
WPA_SUPPLICANT_DBUS_OLD_SERVICE = fi.epitest.hostap.WPASupplicant
WPA_SUPPLICANT_DBUS_NEW_SERVICE = fi.w1.wpa_supplicant1
WPA_SUPPLICANT_CFLAGS = $(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include/libnl3/
WPA_SUPPLICANT_LDFLAGS = $(TARGET_LDFLAGS)

WPA_SUPPLICANT_CONFIG_EDITS =

WPA_SUPPLICANT_CONFIG_SET =

WPA_SUPPLICANT_CONFIG_ENABLE = \
	CONFIG_IEEE80211AC	\
	CONFIG_IEEE80211N	\
	CONFIG_IEEE80211R	\
	CONFIG_INTERWORKING	\
	CONFIG_INTERNAL_LIBTOMMATH

WPA_SUPPLICANT_CONFIG_DISABLE = \
	CONFIG_SMARTCARD

# libnl-3 needs -lm (for rint) and -lpthread if linking statically
# And library order matters hence stick -lnl-3 first since it's appended
# in the wpa_supplicant Makefiles as in LIBS+=-lnl-3 ... thus failing
ifeq ($(BR2_PACKAGE_LIBNL),y)
ifeq ($(BR2_PREFER_STATIC_LIB),y)
	WPA_SUPPLICANT_LIBS += -lnl-3 -lm -lpthread
endif
	WPA_SUPPLICANT_DEPENDENCIES += libnl
	WPA_SUPPLICANT_CONFIG_ENABLE += CONFIG_LIBNL32
else
	WPA_SUPPLICANT_CONFIG_DISABLE += CONFIG_DRIVER_NL80211
endif

# Trailing underscore on purpose to not enable CONFIG_EAPOL_TEST
ifeq ($(BR2_PACKAGE_WPA_SUPPLICANT_EAP),y)
	WPA_SUPPLICANT_CONFIG_ENABLE += CONFIG_EAP_
else
	WPA_SUPPLICANT_CONFIG_DISABLE += CONFIG_EAP
endif

ifeq ($(BR2_PACKAGE_WPA_SUPPLICANT_AP_SUPPORT),y)
	WPA_SUPPLICANT_CONFIG_ENABLE += \
		CONFIG_AP \
		CONFIG_P2P
endif

ifeq ($(BR2_PACKAGE_WPA_SUPPLICANT_WPS),y)
	WPA_SUPPLICANT_CONFIG_ENABLE += CONFIG_WPS
endif

# Try to use openssl if it's already available
ifeq ($(BR2_PACKAGE_OPENSSL),y)
	WPA_SUPPLICANT_DEPENDENCIES += openssl
	WPA_SUPPLICANT_LIBS += $(if $(BR2_PREFER_STATIC_LIB),-lcrypto -lz)
	WPA_SUPPLICANT_CONFIG_EDITS += 's/\#\(CONFIG_TLS=openssl\)/\1/'
else
	WPA_SUPPLICANT_CONFIG_DISABLE += CONFIG_EAP_PWD
	WPA_SUPPLICANT_CONFIG_EDITS += 's/\#\(CONFIG_TLS=\).*/\1internal/'
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
	WPA_SUPPLICANT_DEPENDENCIES += host-pkgconf dbus
	WPA_SUPPLICANT_MAKE_ENV = \
		PKG_CONFIG_SYSROOT_DIR="$(STAGING_DIR)"	\
		PKG_CONFIG_PATH="$(STAGING_DIR)/usr/lib/pkgconfig"

ifeq ($(BR2_PACKAGE_WPA_SUPPLICANT_DBUS_OLD),y)
	WPA_SUPPLICANT_CONFIG_ENABLE += CONFIG_CTRL_IFACE_DBUS=
define WPA_SUPPLICANT_INSTALL_DBUS_OLD
	$(INSTALL) -D \
	  $(@D)/wpa_supplicant/dbus/$(WPA_SUPPLICANT_DBUS_OLD_SERVICE).service \
	  $(TARGET_DIR)/usr/share/dbus-1/system-services/$(WPA_SUPPLICANT_DBUS_OLD_SERVICE).service
endef
endif

ifeq ($(BR2_PACKAGE_WPA_SUPPLICANT_DBUS_NEW),y)
	WPA_SUPPLICANT_CONFIG_ENABLE += CONFIG_CTRL_IFACE_DBUS_NEW
define WPA_SUPPLICANT_INSTALL_DBUS_NEW
	$(INSTALL) -D \
	  $(@D)/wpa_supplicant/dbus/$(WPA_SUPPLICANT_DBUS_NEW_SERVICE).service \
	  $(TARGET_DIR)/usr/share/dbus-1/system-services/$(WPA_SUPPLICANT_DBUS_NEW_SERVICE).service
endef
endif

ifeq ($(BR2_PACKAGE_WPA_SUPPLICANT_DBUS_INTROSPECTION),y)
	WPA_SUPPLICANT_CONFIG_ENABLE += CONFIG_CTRL_IFACE_DBUS_INTRO
endif

endif

ifeq ($(BR2_PACKAGE_WPA_SUPPLICANT_DEBUG_SYSLOG),y)
define WPA_SUPPLICANT_DEBUG_CONFIG
	$(SED) 's/\(#\)\(CONFIG_DEBUG_SYSLOG.*\)/\2/' $(WPA_SUPPLICANT_CONFIG)
endef
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
	WPA_SUPPLICANT_DEPENDENCIES += readline
	WPA_SUPPLICANT_CONFIG_ENABLE += CONFIG_READLINE
endif

define WPA_SUPPLICANT_CONFIGURE_CMDS
	cp $(@D)/wpa_supplicant/defconfig $(WPA_SUPPLICANT_CONFIG)
	sed -i $(patsubst %,-e 's/^#\(%\)/\1/',$(WPA_SUPPLICANT_CONFIG_ENABLE)) \
	       $(patsubst %,-e 's/^\(%\)/#\1/',$(WPA_SUPPLICANT_CONFIG_DISABLE)) \
	       $(patsubst %,-e '1i%=y',$(WPA_SUPPLICANT_CONFIG_SET)) \
	       $(patsubst %,-e %,$(WPA_SUPPLICANT_CONFIG_EDITS)) \
	       $(WPA_SUPPLICANT_CONFIG)
endef

# LIBS for wpa_supplicant, LIBS_c for wpa_cli, LIBS_p for wpa_passphrase
define WPA_SUPPLICANT_BUILD_CMDS
	$(TARGET_MAKE_ENV) CFLAGS="$(WPA_SUPPLICANT_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" BINDIR=/usr/sbin \
		LIBS="$(WPA_SUPPLICANT_LIBS)" LIBS_c="$(WPA_SUPPLICANT_LIBS)" \
		LIBS_p="$(WPA_SUPPLICANT_LIBS)" \
		$(MAKE) CC="$(TARGET_CC)" -C $(@D)/$(WPA_SUPPLICANT_SUBDIR)
endef

ifeq ($(BR2_PACKAGE_WPA_SUPPLICANT_CLI),y)
define WPA_SUPPLICANT_INSTALL_CLI
	$(INSTALL) -m 0755 -D $(@D)/$(WPA_SUPPLICANT_SUBDIR)/wpa_cli \
		$(TARGET_DIR)/usr/sbin/wpa_cli
endef
endif

ifeq ($(BR2_PACKAGE_WPA_SUPPLICANT_PASSPHRASE),y)
define WPA_SUPPLICANT_INSTALL_PASSPHRASE
	$(INSTALL) -m 0755 -D $(@D)/$(WPA_SUPPLICANT_SUBDIR)/wpa_passphrase \
		$(TARGET_DIR)/usr/sbin/wpa_passphrase
endef
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
define WPA_SUPPLICANT_INSTALL_DBUS
	$(INSTALL) -D \
	  $(@D)/wpa_supplicant/dbus/dbus-wpa_supplicant.conf \
	  $(TARGET_DIR)/etc/dbus-1/system.d/wpa_supplicant.conf
	$(WPA_SUPPLICANT_INSTALL_DBUS_OLD)
	$(WPA_SUPPLICANT_INSTALL_DBUS_NEW)
endef
endif

define WPA_SUPPLICANT_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/$(WPA_SUPPLICANT_SUBDIR)/wpa_supplicant \
		$(TARGET_DIR)/usr/sbin/wpa_supplicant
	$(INSTALL) -m 644 -D package/wpa_supplicant/wpa_supplicant.conf \
		$(TARGET_DIR)/etc/wpa_supplicant.conf
	$(WPA_SUPPLICANT_INSTALL_CLI)
	$(WPA_SUPPLICANT_INSTALL_PASSPHRASE)
	$(WPA_SUPPLICANT_INSTALL_DBUS)
endef

$(eval $(generic-package))
