################################################################################
#
# network-manager
#
################################################################################

NETWORK_MANAGER_VERSION_MAJOR = 0.9
NETWORK_MANAGER_VERSION = $(NETWORK_MANAGER_VERSION_MAJOR).8.2
NETWORK_MANAGER_SOURCE = NetworkManager-$(NETWORK_MANAGER_VERSION).tar.xz
NETWORK_MANAGER_SITE = http://ftp.gnome.org/pub/GNOME/sources/NetworkManager/$(NETWORK_MANAGER_VERSION_MAJOR)
NETWORK_MANAGER_INSTALL_STAGING = YES
NETWORK_MANAGER_DEPENDENCIES = host-pkgconf udev dbus-glib libnl gnutls \
	libgcrypt wireless_tools util-linux host-intltool

NETWORK_MANAGER_CONF_ENV = \
	ac_cv_path_LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config \
	ac_cv_file__etc_fedora_release=no \
	ac_cv_file__etc_mandriva_release=no \
	ac_cv_file__etc_debian_version=no \
	ac_cv_file__etc_redhat_release=no \
	ac_cv_file__etc_SuSE_release=no


NETWORK_MANAGER_CONF_OPT = \
		--mandir=$(STAGING_DIR)/usr/man/ \
		--disable-tests \
		--disable-more-warnings \
		--without-docs \
		--disable-gtk-doc \
		--localstatedir=/var \
		--with-crypto=gnutls \
		--disable-ppp \
		--with-iptables=/usr/sbin/iptables \
		--disable-ifupdown \
		--disable-ifnet

ifeq ($(BR2_PACKAGE_DHCP_CLIENT),y)
NETWORK_MANAGER_CONF_OPT += --with-dhclient=/usr/sbin/dhclient
endif

ifeq ($(BR2_PACKAGE_DHCPCD),y)
NETWORK_MANAGER_CONF_OPT += --with-dhcpcd=/usr/sbin/dhcpcd
endif

# uClibc by default doesn't have backtrace support, so don't use it
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
NETWORK_MANAGER_CONF_OPT += --disable-crashtrace
endif

define NETWORK_MANAGER_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/network-manager/S45network-manager $(TARGET_DIR)/etc/init.d/S45network-manager
endef

$(eval $(autotools-package))
