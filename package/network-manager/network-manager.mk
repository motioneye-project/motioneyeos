################################################################################
#
# network-manager
#
################################################################################

NETWORK_MANAGER_VERSION_MAJOR = 1.4
NETWORK_MANAGER_VERSION = $(NETWORK_MANAGER_VERSION_MAJOR).2
NETWORK_MANAGER_SOURCE = NetworkManager-$(NETWORK_MANAGER_VERSION).tar.xz
NETWORK_MANAGER_SITE = http://ftp.gnome.org/pub/GNOME/sources/NetworkManager/$(NETWORK_MANAGER_VERSION_MAJOR)
NETWORK_MANAGER_INSTALL_STAGING = YES
NETWORK_MANAGER_DEPENDENCIES = host-pkgconf udev dbus-glib libnl gnutls \
	libgcrypt wireless_tools util-linux host-intltool readline libndp libgudev
NETWORK_MANAGER_LICENSE = GPL-2.0+ (app), LGPL-2.0+ (libnm-util)
NETWORK_MANAGER_LICENSE_FILES = COPYING libnm-util/COPYING

NETWORK_MANAGER_CONF_ENV = \
	ac_cv_path_LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config \
	ac_cv_file__etc_fedora_release=no \
	ac_cv_file__etc_mandriva_release=no \
	ac_cv_file__etc_debian_version=no \
	ac_cv_file__etc_redhat_release=no \
	ac_cv_file__etc_SuSE_release=no

NETWORK_MANAGER_CONF_OPTS = \
	--disable-tests \
	--disable-qt \
	--disable-more-warnings \
	--without-docs \
	--with-crypto=gnutls \
	--with-iptables=/usr/sbin/iptables \
	--disable-ifupdown \
	--disable-ifnet

ifeq ($(BR2_PACKAGE_NETWORK_MANAGER_TUI),y)
NETWORK_MANAGER_DEPENDENCIES += newt
NETWORK_MANAGER_CONF_OPTS += --with-nmtui=yes
else
NETWORK_MANAGER_CONF_OPTS += --with-nmtui=no
endif

ifeq ($(BR2_PACKAGE_NETWORK_MANAGER_PPPD),y)
NETWORK_MANAGER_DEPENDENCIES += pppd
NETWORK_MANAGER_CONF_OPTS += --enable-ppp
else
NETWORK_MANAGER_CONF_OPTS += --disable-ppp
endif

ifeq ($(BR2_PACKAGE_NETWORK_MANAGER_MODEM_MANAGER),y)
NETWORK_MANAGER_DEPENDENCIES += modem-manager
NETWORK_MANAGER_CONF_OPTS += --with-modem-manager-1
else
NETWORK_MANAGER_CONF_OPTS += --without-modem-manager-1
endif

ifeq ($(BR2_PACKAGE_DHCP_CLIENT),y)
NETWORK_MANAGER_CONF_OPTS += --with-dhclient=/sbin/dhclient
endif

ifeq ($(BR2_PACKAGE_DHCPCD),y)
NETWORK_MANAGER_CONF_OPTS += --with-dhcpcd=/sbin/dhcpcd
endif

# uClibc by default doesn't have backtrace support, so don't use it
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
NETWORK_MANAGER_CONF_OPTS += --disable-crashtrace
endif

define NETWORK_MANAGER_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/network-manager/S45network-manager $(TARGET_DIR)/etc/init.d/S45network-manager
endef

define NETWORK_MANAGER_INSTALL_INIT_SYSTEMD
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants

	ln -sf /usr/lib/systemd/system/NetworkManager.service \
		$(TARGET_DIR)/etc/systemd/system/dbus-org.freedesktop.NetworkManager.service

	ln -sf /usr/lib/systemd/system/NetworkManager.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/NetworkManager.service

	ln -sf /usr/lib/systemd/system/NetworkManager-dispatcher.service \
		$(TARGET_DIR)/etc/systemd/system/dbus-org.freedesktop.nm-dispatcher.service
endef

$(eval $(autotools-package))
