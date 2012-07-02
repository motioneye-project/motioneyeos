#############################################################
#
# transmission
#
#############################################################
TRANSMISSION_VERSION = 2.33
TRANSMISSION_SITE = http://download.transmissionbt.com/files/
TRANSMISSION_SOURCE = transmission-$(TRANSMISSION_VERSION).tar.bz2
TRANSMISSION_DEPENDENCIES = \
	host-pkg-config \
	host-intltool \
	libcurl \
	libevent \
	openssl \
	zlib

TRANSMISSION_CONF_OPT = \
	--disable-libnotify \
	--enable-lightweight

define TRANSMISSION_INIT_SCRIPT_INSTALL
	[ -f $(TARGET_DIR)/etc/init.d/S92transmission ] || \
		$(INSTALL) -m 0755 -D package/transmission/S92transmission \
			$(TARGET_DIR)/etc/init.d/S92transmission
endef

ifeq ($(BR2_PACKAGE_TRANSMISSION_UTP),y)
	TRANSMISSION_CONF_OPT += --enable-utp
else
	TRANSMISSION_CONF_OPT += --disable-utp
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_CLI),y)
	TRANSMISSION_CONF_OPT += --enable-cli
else
	TRANSMISSION_CONF_OPT += --disable-cli
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_DAEMON),y)
	TRANSMISSION_CONF_OPT += --enable-daemon
	TRANSMISSION_POST_INSTALL_TARGET_HOOKS += TRANSMISSION_INIT_SCRIPT_INSTALL
else
	TRANSMISSION_CONF_OPT += --disable-daemon
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_REMOTE),y)
	TRANSMISSION_CONF_OPT += --enable-remote
else
	TRANSMISSION_CONF_OPT += --disable-remote
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_GTK),y)
	TRANSMISSION_CONF_OPT += --enable-gtk
	TRANSMISSION_DEPENDENCIES += libgtk2
else
	TRANSMISSION_CONF_OPT += --disable-gtk
endif

$(eval $(autotools-package))
