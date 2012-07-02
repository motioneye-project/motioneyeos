#############################################################
#
# NetworkManager
#
#############################################################
NETWORK_MANAGER_VERSION = 0.9.2.0
NETWORK_MANAGER_SOURCE = NetworkManager-$(NETWORK_MANAGER_VERSION).tar.bz2
NETWORK_MANAGER_SITE = http://ftp.gnome.org/pub/GNOME/sources/NetworkManager/0.9/
NETWORK_MANAGER_INSTALL_STAGING = YES
NETWORK_MANAGER_DEPENDENCIES = host-pkg-config udev dbus-glib libnl wireless_tools gnutls util-linux

NETWORK_MANAGER_CONF_ENV = \
	ac_cv_path_LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config

NETWORK_MANAGER_CONF_OPT = \
		--mandir=$(STAGING_DIR)/usr/man/ \
		--with-dbus-user=dbus \
		--disable-tests \
		--disable-more-warnings \
		--without-docs \
		--disable-gtk-doc \
		--disable-asserts \
		--enable-abstract-sockets \
		--disable-selinux \
		--disable-xml-docs \
		--disable-doxygen-docs \
		--disable-static \
		--enable-dnotify \
		--localstatedir=/var \
		--with-crypto=gnutls \
		--with-distro=arch \
		--disable-ppp \
		--with-iptables=/usr/sbin/iptables

# uClibc by default doesn't have backtrace support, so don't use it
ifeq ($(BR2_TOOLCHAIN_BUILDROOT)$(BR2_TOOLCHAIN_EXTERNAL_UCLIBC)$(BR2_TOOLCHAIN_CTNG_uClibc),y)
NETWORK_MANAGER_CONF_OPT += --disable-crashtrace
endif

# The target was built for the archlinux distribution, so we need
# to move around things after installation
define NETWORK_MANAGER_INSTALL_INITSCRIPT
	$(INSTALL) -m 0755 -D package/network-manager/S45network-manager $(TARGET_DIR)/etc/init.d/S45network-manager
	rm -f $(TARGET_DIR)/etc/rc.d/networkmanager
	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/etc/rc.d
endef

NETWORK_MANAGER_POST_INSTALL_TARGET_HOOKS += NETWORK_MANAGER_INSTALL_INITSCRIPT

$(eval $(autotools-package))
