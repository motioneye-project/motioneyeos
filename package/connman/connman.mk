#######################################################
#
# connman - open source connection manager
#
#######################################################

CONNMAN_VERSION = 1.4
CONNMAN_SITE = $(BR2_KERNEL_MIRROR)/linux/network/connman/
CONNMAN_DEPENDENCIES = libglib2 dbus iptables gnutls
CONNMAN_INSTALL_STAGING = YES
CONNMAN_CONF_OPT += --localstatedir=/var \
	$(if $(BR2_PACKAGE_CONNMAN_THREADS),--enable-threads,--disable-threads)		\
	$(if $(BR2_PACKAGE_CONNMAN_DEBUG),--enable-debug,--disable-debug)		\
	$(if $(BR2_PACKAGE_CONNMAN_ETHERNET),--enable-ethernet,--disable-ethernet)	\
	$(if $(BR2_PACKAGE_CONNMAN_WIFI),--enable-wifi,--disable-wifi)			\
	$(if $(BR2_PACKAGE_CONNMAN_BLUETOOTH),--enable-bluetooth,--disable-bluetooth)	\
	$(if $(BR2_PACKAGE_CONNMAN_LOOPBACK),--enable-loopback,--disable-loopback)	\
	$(if $(BR2_PACKAGE_CONNMAN_NTPD),--enable-ntpd,--disable-ntpd)

define CONNMAN_INSTALL_INITSCRIPT
	$(INSTALL) -m 0755 -D package/connman/S45connman $(TARGET_DIR)/etc/init.d/S45connman
endef

CONNMAN_POST_INSTALL_TARGET_HOOKS = CONNMAN_INSTALL_INITSCRIPT

ifeq ($(BR2_PACKAGE_CONNMAN_CLIENT),y)
CONNMAN_CONF_OPT += --enable-client

define CONNMAN_INSTALL_CM
	$(INSTALL) -m 0755 -D $(@D)/client/cm $(TARGET_DIR)/usr/bin/cm
endef

CONNMAN_POST_INSTALL_TARGET_HOOKS += CONNMAN_INSTALL_CM
endif

$(eval $(autotools-package))
